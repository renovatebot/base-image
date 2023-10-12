FROM ghcr.io/containerbase/base:9.20.13@sha256:9d5c018646811190c6eae482ac7d8be90f3817378903f57b3fe6d9616e7fe8f4 AS base

LABEL name="base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.18.0

# renovate: datasource=npm
RUN install-tool corepack 0.20.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.6
