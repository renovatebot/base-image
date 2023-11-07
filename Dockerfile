FROM ghcr.io/containerbase/base:9.23.13@sha256:d14b5f27fae55a2a016a2ddd116508d95fbb4269d85f845a6ede57f342265014 AS base

LABEL name="base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.18.2

# renovate: datasource=npm
RUN install-tool corepack 0.22.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.7
