ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/sidecar:11.11.30@sha256:109b369dd571a488e27e9e7076098367fa3041c3d7b7c78449b80d86f787a616 AS base

# sidecar defaults to 1000
USER root

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"

# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 20.18.0

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v27.3.1

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
RUN install-tool gradle 8.10.2


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 27.1.1.0

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.17.3


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.3.12

# renovate: datasource=github-releases packageName=composer/composer
RUN install-tool composer 2.8.1


# renovate: datasource=golang-version
RUN install-tool golang 1.23.2


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.12.7

# renovate: datasource=pypi
RUN install-tool conan 2.8.0

# renovate: datasource=pypi
RUN install-tool hashin 1.0.2

# renovate: datasource=pypi
RUN install-tool pdm 2.19.1

# renovate: datasource=pypi
RUN install-tool pip-tools 7.4.1

# renovate: datasource=pypi
RUN install-tool pipenv 2024.1.0

# renovate: datasource=pypi
RUN install-tool poetry 1.8.3


# renovate: datasource=docker
RUN install-tool rust 1.81.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 3.3.5

# renovate: datasource=rubygems
RUN install-tool bundler 2.5.21

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.15.2


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 8.0.402


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v3.16.1


# renovate: datasource=github-releases packageName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.6.0


# renovate: datasource=npm
RUN install-tool bun 1.1.29


# renovate: datasource=github-tags packageName=NixOS/nix
RUN install-tool nix 2.24.9


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.22.0


# renovate: datasource=npm
RUN install-tool pnpm 9.12.0

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.5.0

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

