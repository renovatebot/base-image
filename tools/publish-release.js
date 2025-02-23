import { Command, Option, runExit } from 'clipanion';
import shell from 'shelljs';

class ReleaseCommand extends Command {
  release = Option.String('-r,--release', { required: true });
  channel = Option.String('-c,--channel', { required: true });
  gitSha = Option.String('--sha');
  dryRun = Option.Boolean('-d,--dry-run');

  async execute() {
    /** @type {shell.ShellString} */
    let r;
    const { release, gitSha, dryRun, channel } = this;

    shell.echo(`Publish version: ${release} (${gitSha}, ${channel})`);
    process.env.TAG = release;
    process.env.BASE_IMAGE_VERSION = release;

    if (channel) {
      process.env.CHANNEL = channel;
    }

    if (dryRun) {
      shell.echo('DRY-RUN: done.');
      return 0;
    }

    shell.echo('Pushing cache');
    r = shell.exec(
      'docker buildx bake push-cache --set settings.platform=linux/amd64,linux/arm64',
    );
    if (r.code) {
      return 1;
    }

    shell.echo('Pushing docker images');
    r = shell.exec(
      'docker buildx bake --set settings.platform=linux/amd64,linux/arm64 push',
    );
    if (r.code) {
      return 1;
    }

    r = shell.exec(
      `cosign sign --yes ghcr.io/${process.env.OWNER}/${process.env.FILE}:${process.env.TAG}`,
    );
    if (r.code) {
      return 1;
    }

    r = shell.exec(
      `cosign sign --yes ghcr.io/${process.env.OWNER}/${process.env.FILE}:${process.env.TAG}-full`,
    );
    if (r.code) {
      return 1;
    }

    return 0;
  }
}

void runExit(ReleaseCommand);
