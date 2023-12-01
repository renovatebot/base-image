FROM ghcr.io/containerbase/base:9.26.0@sha256:d64249bced930342154688a79d0bc537423c2e5918c476361e0e22f5fd734c83 AS base

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.19.0

RUN corepack enable

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.7

# --------------------------------------
# final image
# TODO add stages for full image
# --------------------------------------
FROM base

ARG BASE_IMAGE_VERSION
ARG BASE_IMAGE_REVISION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}" \
  org.opencontainers.image.revision="${BASE_IMAGE_REVISION}"

