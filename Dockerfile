FROM ghcr.io/containerbase/base:9.20.11@sha256:9bd603648e648ba5c80cb48f7292c46c9523b4786c6d10320d44a50aad7b7eeb AS base

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
