ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:13.5.2@sha256:2a18112768672af13cda1e6888736573d0caf7734aca2806a8005ee82944788e AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"


# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v27.4.1

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
RUN install-tool java 21.0.5+11.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 8.12


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 27.1.2.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.18.0


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.3.14

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.8.4


# renovate: datasource=golang-version
RUN install-tool golang 1.23.4


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.13.1

# renovate: datasource=pypi
RUN install-tool conan 2.11.0

# renovate: datasource=pypi
RUN install-tool hashin 1.0.3

# renovate: datasource=pypi
RUN install-tool pdm 2.22.1

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=pypi
RUN install-tool pipenv 2024.4.0

# renovate: datasource=pypi
RUN install-tool poetry 1.8.5

# renovate: datasource=pypi
RUN install-tool uv 0.5.11


# renovate: datasource=docker
RUN install-tool rust 1.83.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.3.6

# renovate: datasource=rubygems
RUN install-tool bundler 2.6.2

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.16.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 8.0.404


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.16.4


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.1.39


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.25.3


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.25.0


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 22.12.0

# renovate: datasource=npm
RUN install-tool pnpm 9.15.0

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.5.3

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

