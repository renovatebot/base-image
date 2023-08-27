FROM ghcr.io/containerbase/base:9.19.3@sha256:6878fdecd861d6410dc02f400289fb874b7371fb7fbad2014868d2fd6089abf1 AS base

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
