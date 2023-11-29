FROM ghcr.io/containerbase/base:9.25.0@sha256:f0d880fff787b8a67b44f745d111b9336488754e7077903b91c4a761b5aee820 AS base

LABEL name="base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.19.0

# renovate: datasource=npm
RUN install-tool corepack 0.23.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.7
