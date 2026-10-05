# Renovate base-image

This repository is the base image for our [`renovatebot/renovate` Docker images](https://hub.docker.com/r/renovate/renovate).

It is built from [`ghcr.io/containerbase/base`](https://github.com/containerbase/base) and runs `prepare-tool all`, so all Containerbase tools except the root-only ones (`root: true`) can be installed at runtime without root.
