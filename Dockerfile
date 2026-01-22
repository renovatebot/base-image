ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:13.26.6@sha256:316f999a4f203afd05038a947884198171b1c4f4379f966bed4a7cd23d42a825 AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"


# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v28.5.2

# --------------------------------------
# slim image
# --------------------------------------
FROM base AS slim-base

# --------------------------------------
# full image
# --------------------------------------
FROM base AS full-base

ARG APT_HTTP_PROXY

# linux x64 is usually released after aarch64
# renovate: datasource=java-version packageName=java?os=linux&architecture=x64
RUN install-tool java 25.0.1+8.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 9.3.0


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 28.3.1.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.19.5


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.4.14

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.9.3


# renovate: datasource=golang-version
RUN install-tool golang 1.25.6


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.14.2

# renovate: datasource=pypi
RUN install-tool conan 2.24.0

# renovate: datasource=pypi
RUN install-tool copier 9.11.2

# renovate: datasource=pypi
RUN install-tool hashin 1.0.5

# renovate: datasource=pypi
RUN install-tool pdm 2.26.5

# renovate: datasource=pypi
RUN install-tool pip-tools 7.5.2

# renovate: datasource=pypi
RUN install-tool pipenv 2025.1.3

# renovate: datasource=pypi
RUN install-tool poetry 2.3.1

# renovate: datasource=pypi
RUN install-tool uv 0.9.26


# renovate: datasource=docker
RUN install-tool rust 1.92.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.4.8

# renovate: datasource=rubygems
RUN install-tool bundler 2.7.2

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.16.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 9.0.310


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v4.1.0


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.3.6


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.33.1


# renovate: datasource=github-releases packageName=jetify-com/devbox
RUN install-tool devbox 0.16.0


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.28.1


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 24.13.0

# renovate: datasource=npm
RUN install-tool pnpm 10.28.0

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.12.0


# renovate: datasource=dart-version
RUN install-tool dart 3.10.7

# renovate: datasource=github-releases packageName=containerbase/flutter-prebuild
RUN install-tool flutter 3.38.7

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

