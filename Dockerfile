FROM ghcr.io/containerbase/base:9.20.0@sha256:4f8fc3d79c5c01401d3ad2e746b8b0da4490d7480c575e4ca5575d0e329e4e47 AS base

LABEL name="base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.17.1

# renovate: datasource=npm
RUN install-tool corepack 0.20.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.6
