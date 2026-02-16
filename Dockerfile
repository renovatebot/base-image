ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:14.1.2@sha256:59c8fa611bafcd903045a4ff10b19823401cdb2d44b5f5f04372dca5e364cb05 AS base

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
RUN install-tool java 25.0.2+10.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 9.3.1


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 28.3.1.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.19.5


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.5.3

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.9.5


# renovate: datasource=golang-version
RUN install-tool golang 1.26.0


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.14.3

# renovate: datasource=pypi
RUN install-tool conan 2.25.2

# renovate: datasource=pypi
RUN install-tool copier 9.11.3

# renovate: datasource=pypi
RUN install-tool hashin 1.0.5

# renovate: datasource=pypi
RUN install-tool pdm 2.26.6

# renovate: datasource=pypi
RUN install-tool pip-tools 7.5.3

# renovate: datasource=pypi
RUN install-tool pipenv 2026.0.3

# renovate: datasource=pypi
RUN install-tool poetry 2.3.2

# renovate: datasource=pypi
RUN install-tool uv 0.10.2


# renovate: datasource=docker
RUN install-tool rust 1.93.1


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 4.0.1

# renovate: datasource=rubygems
RUN install-tool bundler 4.0.6

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.16.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 10.0.103


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v4.1.1


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.3.9


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.33.3


# renovate: datasource=github-releases packageName=jetify-com/devbox
RUN install-tool devbox 0.16.0


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.28.1


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 24.13.1

# renovate: datasource=npm
RUN install-tool pnpm 10.29.2

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.12.0


# renovate: datasource=dart-version
RUN install-tool dart 3.11.0

# renovate: datasource=github-releases packageName=containerbase/flutter-prebuild
RUN install-tool flutter 3.41.1

# renovate: datasource=github-releases packageName=carvel-dev/vendir
RUN install-tool vendir v0.45.1

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

