ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:10.6.11@sha256:2d64ed22bcc7f411d57d025908b9dc139f76df2898d49aad22e326a3b4eee07e AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT" \
  org.label-schema.vcs-url="https://github.com/renovatebot/base-image"

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 18.20.2

# renovate: datasource=npm
RUN install-tool pnpm 8.15.8

# renovate: datasource=npm
RUN install-tool yarn 1.22.22


# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.9

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
RUN install-tool java 17.0.11+9

# renovate: datasource=gradle-version
RUN install-tool gradle 8.7


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 26.2.5.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.16.2


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.3.7

# renovate: datasource=github-releases packageName=composer/composer
RUN install-tool composer 2.7.6


# renovate: datasource=golang-version
RUN install-tool golang 1.22.3


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.3

# renovate: datasource=pypi
RUN install-tool conan 2.3.1

# renovate: datasource=pypi
RUN install-tool hashin 0.17.0

# renovate: datasource=pypi
RUN install-tool pdm 2.15.2

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=pypi
RUN install-tool pipenv 2023.12.1

# renovate: datasource=pypi
RUN install-tool poetry 1.8.3


# renovate: datasource=docker
RUN install-tool rust 1.78.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.3.1

# renovate: datasource=rubygems
RUN install-tool bundler 2.5.10

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.15.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 7.0.409


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.15.0


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1


# renovate: datasource=npm
RUN install-tool bun 1.1.8


# renovate: datasource=github-tags packageName=NixOS/nix
RUN install-tool nix 2.22.1


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.20.0

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}" \
  org.label-schema.version="${BASE_IMAGE_VERSION}"

