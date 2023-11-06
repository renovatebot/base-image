FROM ghcr.io/containerbase/base:9.23.12@sha256:7200ea0cc7bb19a9d33881a14da2bc0208daf7553cadc0fff084ad158e372c50 AS base

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
