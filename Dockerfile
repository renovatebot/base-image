FROM ghcr.io/containerbase/base:9.23.11@sha256:1c0284d0dac8e024177da0bd01dd514c53db0a5fc9385d8688878a77164e645d AS base

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
