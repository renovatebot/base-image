ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:13.13.6@sha256:fdd0b9ad12d0ad3a056f32ff1f29b5218e41d32eb3eb3f49014c9947c61987d4 AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"


# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v28.4.0

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
RUN install-tool java 21.0.8+9.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 8.14.3


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 27.3.4.3

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.18.4


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.4.12

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.8.11


# renovate: datasource=golang-version
RUN install-tool golang 1.25.1


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.13.7

# renovate: datasource=pypi
RUN install-tool conan 2.20.1

# renovate: datasource=pypi
RUN install-tool copier 9.10.2

# renovate: datasource=pypi
RUN install-tool hashin 1.0.5

# renovate: datasource=pypi
RUN install-tool pdm 2.25.9

# renovate: datasource=pypi
RUN install-tool pip-tools 7.5.0

# renovate: datasource=pypi
RUN install-tool pipenv 2025.0.4

# renovate: datasource=pypi
RUN install-tool poetry 2.2.0

# renovate: datasource=pypi
RUN install-tool uv 0.8.17


# renovate: datasource=docker
RUN install-tool rust 1.89.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.4.6

# renovate: datasource=rubygems
RUN install-tool bundler 2.7.2

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.16.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 9.0.305


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.19.0


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.2.21


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.31.1


# renovate: datasource=github-releases packageName=jetify-com/devbox
RUN install-tool devbox 0.16.0


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.27.0


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 22.19.0

# renovate: datasource=npm
RUN install-tool pnpm 10.15.1

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.9.4


# renovate: datasource=dart-version
RUN install-tool dart 3.9.3

# renovate: datasource=flutter-version
RUN install-tool flutter 3.35.4

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

