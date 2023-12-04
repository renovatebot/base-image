ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:9.27.0@sha256:e924f08481d793a25084f40b4f87164b569e971013cab0bebfa23ea68615d8b2 AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT" \
  org.label-schema.vcs-url="https://github.com/renovatebot/base-image"

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node v18.19.0

# renovate: datasource=npm depName=pnpm
ARG PNPM_VERSION=8.11.0

# renovate: datasource=npm depName=yarn
ARG YARN_VERSION=1.22.21

# enable corepack and precache yarn and pnpm
RUN set -ex; \
  corepack enable; \
  corepack install --global pnpm@${PNPM_VERSION} yarn@${YARN_VERSION}; \
  pnpm --version; \
  yarn --version; \
  true

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.7

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
RUN install-tool java 17.0.9+9

# renovate: datasource=gradle-version
RUN install-tool gradle 8.5

# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 26.1.2.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir 1.15.7

# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.2.13

# renovate: datasource=github-releases packageName=composer/composer
RUN install-tool composer 2.6.5

# renovate: datasource=golang-version
RUN install-tool golang 1.21.4

# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.0

# renovate: datasource=pypi
RUN install-tool pipenv 2023.11.15

# renovate: datasource=github-releases packageName=python-poetry/poetry
RUN install-tool poetry 1.7.1

# renovate: datasource=pypi
RUN install-tool hashin 0.17.0

# renovate: datasource=pypi
RUN install-tool pip-tools 7.3.0

# renovate: datasource=docker
RUN install-tool rust 1.74.0

# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.2.2

# renovate: datasource=rubygems
RUN install-tool bundler 2.4.22

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.14.3

# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 7.0.404

# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.13.2

# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

# renovate: datasource=npm
RUN install-tool bun 1.0.14

# renovate: datasource=github-tags packageName=NixOS/nix
RUN install-tool nix 2.19.2

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

