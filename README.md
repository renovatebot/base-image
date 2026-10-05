# Renovate base-image

This repository is the base image for our [`renovatebot/renovate` Docker images](https://hub.docker.com/r/renovate/renovate).

It is built from [`ghcr.io/containerbase/base`](https://github.com/containerbase/base) and runs `prepare-tool all`, so all Containerbase tools except the root-only ones (`root: true`) can be installed at runtime without root.

## npm package

Each release also publishes the [`@renovatebot/base-image`](./packages/base-image/) npm package with the same version.
It re-exports [`@containerbase/base`](https://www.npmjs.com/package/@containerbase/base) at the Containerbase version of the image, so consumers can look up the tools that the image supports.
`pnpm check:containerbase` verifies that the `@containerbase/base` dependency matches the image in the [`Dockerfile`](./Dockerfile).
