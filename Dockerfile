ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:13.8.51@sha256:699f96e2b2610a0878d4ba9cfee0eb981a114396cbc64ab5bf9900ff22a170c0 AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"


# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v28.3.1

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
RUN install-tool gradle 8.14.3


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 27.3.4.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.18.4


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.4.10

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.8.9


# renovate: datasource=golang-version
RUN install-tool golang 1.24.4


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.13.5

# renovate: datasource=pypi
RUN install-tool conan 2.18.1

# renovate: datasource=pypi
RUN install-tool copier 9.7.1

# renovate: datasource=pypi
RUN install-tool hashin 1.0.5

# renovate: datasource=pypi
RUN install-tool pdm 2.25.4

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=pypi
RUN install-tool pipenv 2025.0.3

# renovate: datasource=pypi
RUN install-tool poetry 2.1.3

# renovate: datasource=pypi
RUN install-tool uv 0.7.19


# renovate: datasource=docker
RUN install-tool rust 1.88.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.4.4

# renovate: datasource=rubygems
RUN install-tool bundler 2.6.9

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.16.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 9.0.301


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.18.3


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.2.17


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.29.1


# renovate: datasource=github-releases packageName=jetify-com/devbox
RUN install-tool devbox 0.14.2


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.26.0


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 22.17.0

# renovate: datasource=npm
RUN install-tool pnpm 10.12.4

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.9.2


# renovate: datasource=dart-version
RUN install-tool dart 3.8.1

# renovate: datasource=flutter-version
RUN install-tool flutter 3.32.5

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

