FROM ghcr.io/containerbase/base:9.23.7@sha256:7f48bd13d463909affcf65769692f39f307e3bd4865b24daa87362ea95be9be8 AS base

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
RUN install-tool docker v24.0.6
