FROM ghcr.io/containerbase/base:9.20.6@sha256:02efde32631b5b7e494fc12df841f5d82b4d80de0afe978d0dfca79d1c9219a3 AS base

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
