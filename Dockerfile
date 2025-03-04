ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:13.8.4@sha256:a3b46b12a8fe1314516f25b6c5e85735fbb83be8b7a2bdc5c146386197c366fb AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"


# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v27.5.1

# --------------------------------------
# slim image
# --------------------------------------
FROM base AS slim-base

# --------------------------------------
# full image
# --------------------------------------
FROM base AS full-base

ARG APT_HTTP_PROXY

# renovate: datasource=java-version
RUN install-tool java 21.0.6+7.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 8.13


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 27.2.4.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.18.2


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.3.14

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.8.6


# renovate: datasource=golang-version
RUN install-tool golang 1.24.0


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.13.2

# renovate: datasource=pypi
RUN install-tool conan 2.13.0

# renovate: datasource=pypi
RUN install-tool hashin 1.0.3

# renovate: datasource=pypi
RUN install-tool pdm 2.22.3

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=pypi
RUN install-tool pipenv 2024.4.1

# renovate: datasource=pypi
RUN install-tool poetry 1.8.5

# renovate: datasource=pypi
RUN install-tool uv 0.6.4


# renovate: datasource=docker
RUN install-tool rust 1.85.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.3.6

# renovate: datasource=rubygems
RUN install-tool bundler 2.6.5

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.16.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 8.0.406


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.17.1


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.2.3


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.26.2


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.25.0


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 22.14.0

# renovate: datasource=npm
RUN install-tool pnpm 9.15.6

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.6.0


# renovate: datasource=dart-version
RUN install-tool dart 3.7.1

# renovate: datasource=flutter-version
RUN install-tool flutter 3.27.4

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

