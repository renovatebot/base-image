ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:13.8.28@sha256:748d8578a22dfdcdb310db61610d10942cc308444e6336cdfda3c3715321aebb AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"


# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v28.1.1

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
RUN install-tool java 21.0.7+6.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 8.14


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 27.3.3.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.18.3


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.4.7

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.8.9


# renovate: datasource=golang-version
RUN install-tool golang 1.24.3


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.13.3

# renovate: datasource=pypi
RUN install-tool conan 2.16.1

# renovate: datasource=pypi
RUN install-tool hashin 1.0.3

# renovate: datasource=pypi
RUN install-tool pdm 2.24.1

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=pypi
RUN install-tool pipenv 2025.0.2

# renovate: datasource=pypi
RUN install-tool poetry 2.1.3

# renovate: datasource=pypi
RUN install-tool uv 0.7.6


# renovate: datasource=docker
RUN install-tool rust 1.87.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.4.4

# renovate: datasource=rubygems
RUN install-tool bundler 2.6.9

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.16.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 9.0.300


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.18.0


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.2.13


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.28.3


# renovate: datasource=github-releases packageName=jetify-com/devbox
RUN install-tool devbox 0.14.2


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.26.0


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 22.15.1

# renovate: datasource=npm
RUN install-tool pnpm 10.11.0

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.9.1


# renovate: datasource=dart-version
RUN install-tool dart 3.7.3

# renovate: datasource=flutter-version
RUN install-tool flutter 3.29.3

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

