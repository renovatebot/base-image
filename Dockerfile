FROM ghcr.io/containerbase/base:9.10.5@sha256:9dd6607b6bd04186f258c121f80fec7af5ef61a57821afaac47b4523fa87908e AS base

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
