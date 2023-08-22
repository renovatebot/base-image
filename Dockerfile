FROM ghcr.io/containerbase/base:9.15.0@sha256:24e0c830ebd19f3a2a0bf18ce7cb8fc6fbcc1537b64c1850c44808247fe00a75 AS base

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
