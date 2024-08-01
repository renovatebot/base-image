ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:11.6.5@sha256:a01990e7b3d9755e4abf922886b0f29033cda6c089c7c69faa17093c21e9e525 AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 20.16.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v27.1.1

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
RUN install-tool java 21.0.4+7.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 8.9


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 27.0.0.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.17.2


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.3.9

# renovate: datasource=github-releases packageName=composer/composer
RUN install-tool composer 2.7.7


# renovate: datasource=golang-version
RUN install-tool golang 1.22.5


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.4

# renovate: datasource=pypi
RUN install-tool conan 2.6.0

# renovate: datasource=pypi
RUN install-tool hashin 1.0.1

# renovate: datasource=pypi
RUN install-tool pdm 2.17.3

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=pypi
RUN install-tool pipenv 2024.0.1

# renovate: datasource=pypi
RUN install-tool poetry 1.8.3


# renovate: datasource=docker
RUN install-tool rust 1.80.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.3.4

# renovate: datasource=rubygems
RUN install-tool bundler 2.5.17

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.15.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 8.0.303


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.15.3


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1


# renovate: datasource=npm
RUN install-tool bun 1.1.20


# renovate: datasource=github-tags packageName=NixOS/nix
RUN install-tool nix 2.23.3


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.20.0


# renovate: datasource=npm
RUN install-tool pnpm 9.6.0

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.3.1

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

