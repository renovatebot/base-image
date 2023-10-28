FROM ghcr.io/containerbase/base:9.23.8@sha256:c55f74e486fa74dde672f971b8025a13c4119bdda177363cfca600595a900117 AS base

LABEL name="base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.18.2

# renovate: datasource=npm
RUN install-tool corepack 0.21.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.7
