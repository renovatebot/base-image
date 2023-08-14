FROM ghcr.io/containerbase/base:9.8.2@sha256:f41dc51323ab4839fa7e1242750363497fa45aec9d08f93ce2b42c5b10a581e7 AS base

LABEL name="base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.17.1

# renovate: datasource=npm
RUN install-tool corepack 0.19.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.5
