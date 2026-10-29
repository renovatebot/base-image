import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { execa } from 'execa';

/** @typedef {import('semantic-release').PrepareContext} PrepareContext */
/** @typedef {import('semantic-release').PublishContext} PublishContext */
/** @typedef {import('semantic-release').SuccessContext} SuccessContext */

/** Pushed images to sign, set by `publish` and signed in `success`. */
let images = [];

/**
 * Creates an error without stack trace, semantic-release logs plain errors
 * with their whole stack and the command output is already in the log.
 * @param {string} message
 */
function releaseError(message) {
  const err = new Error(message);
  err.stack = `${err.name}: ${err.message}`;
  return err;
}

/**
 * Runs a command without throwing, its output goes straight to the log.
 * @param {string} file
 * @param {string[]} args
 */
function run(file, args) {
  return execa(file, args, { reject: false, stdio: 'inherit' });
}

/**
 * Runs a command and throws when it fails.
 * @param {string} file
 * @param {string[]} args
 */
async function exec(file, args) {
  const result = await run(file, args);
  if (result.failed) {
    throw releaseError(result.shortMessage);
  }
}

/** Platforms of the release images. */
const platforms = '--set=settings.platform=linux/amd64,linux/arm64';

/**
 * Sets the env the docker bake file reads for the release.
 * @param {PrepareContext} context
 */
function setReleaseEnv({ branch, nextRelease }) {
  process.env.TAG = nextRelease.version;
  process.env.BASE_IMAGE_VERSION = nextRelease.version;

  if (branch.channel) {
    process.env.CHANNEL = branch.channel.replace('maint/', '');
  }
}

/**
 * Builds the images.
 * @param {unknown} _config
 * @param {PrepareContext} context
 */
export async function prepare(_config, context) {
  const { branch, logger, nextRelease } = context;
  logger.log(
    `Preparing version: ${nextRelease.version} (${nextRelease.gitHead}, ${branch.channel ?? ''})`,
  );
  setReleaseEnv(context);

  await exec('docker', ['buildx', 'bake', platforms]);
}

/**
 * Pushes the cache and the images, they are signed in `success` after all
 * plugins published.
 * @param {unknown} _config
 * @param {PublishContext} context
 */
export async function publish(_config, context) {
  const { branch, logger, nextRelease } = context;
  logger.log(
    `Publish version: ${nextRelease.version} (${nextRelease.gitHead}, ${branch.channel ?? ''})`,
  );
  setReleaseEnv(context);

  logger.log('Pushing cache');
  await exec('docker', ['buildx', 'bake', 'push-cache', platforms]);

  const tmp = await fs.mkdtemp(path.join(os.tmpdir(), 'docker-bake-'));
  const metadataFile = path.join(tmp, 'metadata.json');

  logger.log('Pushing docker images');
  await exec('docker', [
    'buildx',
    'bake',
    platforms,
    '--metadata-file',
    metadataFile,
    'push',
  ]);

  const meta = JSON.parse(await fs.readFile(metadataFile, 'utf8'));
  const image = `ghcr.io/${process.env.OWNER}/${process.env.FILE}`;
  images = [];
  for (const target of ['push-slim', 'push-full']) {
    const digest = meta?.[target]?.['containerimage.digest'];
    if (!digest) {
      logger.error(`Bake metadata:\n${JSON.stringify(meta, null, 2)}`);
      throw releaseError(`Missing image digest for ${target}`);
    }
    images.push(`${image}@${digest}`);
  }
}

/**
 * Signs the pushed images. A failed signing doesn't fail the release, it is
 * reported as a GitHub Actions error annotation instead.
 * @param {unknown} _config
 * @param {SuccessContext} context
 */
export async function success(_config, { logger }) {
  for (const image of images) {
    const result = await run('cosign', ['sign', '--yes', image]);
    if (result.failed) {
      logger.error(result.shortMessage);
      process.stdout.write(
        // an annotation ends at the first newline
        `::error title=Image signing failed::${result.shortMessage.split('\n')[0]}\n`,
      );
    }
  }
}
