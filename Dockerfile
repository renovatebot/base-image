ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:10.3.15@sha256:cff5517b7f5ce24e161536a4dc1f3a41e03c98e2313c37b809b5e77d296d5b19 AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT" \
  org.label-schema.vcs-url="https://github.com/renovatebot/base-image"

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 20.12.2

# renovate: datasource=npm
RUN install-tool corepack 0.26.0

# renovate: datasource=npm depName=pnpm
ARG PNPM_VERSION=8.15.6

# renovate: datasource=npm depName=yarn
ARG YARN_VERSION=1.22.22

# enable corepack and precache yarn and pnpm
RUN set -ex; \
  corepack install --global pnpm@${PNPM_VERSION} yarn@${YARN_VERSION}; \
  pnpm --version; \
  yarn --version; \
  true

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v26.0.1

# --------------------------------------
# slim image
# --------------------------------------
FROM base as slim-base

# --------------------------------------
# full image
# --------------------------------------
FROM base as full-base

ARG APT_HTTP_PROXY

# renovate: datasource=java-version
RUN install-tool java 21.0.3+9.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 8.7

# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 26.2.4.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.16.2

# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.3.6

# renovate: datasource=github-releases packageName=composer/composer
RUN install-tool composer 2.7.2

# renovate: datasource=golang-version
RUN install-tool golang 1.22.2

# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.3

# renovate: datasource=pypi
RUN install-tool pipenv 2023.12.1

# renovate: datasource=github-releases packageName=python-poetry/poetry
RUN install-tool poetry 1.8.2

# renovate: datasource=pypi
RUN install-tool hashin 1.0.1

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=docker
RUN install-tool rust 1.77.2

# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.3.0

# renovate: datasource=rubygems
RUN install-tool bundler 2.5.9

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.15.2

# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 8.0.204

# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.14.4

# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

# renovate: datasource=npm
RUN install-tool bun 1.1.3

# renovate: datasource=github-tags packageName=NixOS/nix
RUN install-tool nix 2.21.2

# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.19.0

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}" \
  org.label-schema.version="${BASE_IMAGE_VERSION}"

