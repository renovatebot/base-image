import { readFile } from 'node:fs/promises';

// keep the `@containerbase/base` npm dependency on the image's containerbase version
const dockerfile = await readFile('Dockerfile', 'utf8');
const pkg = JSON.parse(
  await readFile('packages/base-image/package.json', 'utf8'),
);

const image = /^FROM ghcr\.io\/containerbase\/base:(\S+?)(?:@\S+)?\s/m.exec(
  dockerfile,
)?.[1];
const dep = pkg.dependencies['@containerbase/base'];

if (!image) {
  console.error('No `ghcr.io/containerbase/base` image found in Dockerfile');
  process.exit(1);
}

if (image !== dep) {
  console.error(
    `@containerbase/base ${dep} doesn't match the containerbase image ${image}`,
  );
  process.exit(1);
}

console.log(`@containerbase/base matches the containerbase image ${image}`);
