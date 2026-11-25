ARG BASE_IMAGE_TYPE=slim

FROM ghcr.io/containerbase/base:14.70.0@sha256:e760a3f8b3ab14137f916fe5aa4cfdaf0516d265697cde47e81faf2f723f3ae4 AS base

ARG APT_HTTP_PROXY

LABEL name="renovate/base-image"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/base-image" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="MIT"

# install the prerequisites of all tools, so they can be installed at runtime without root
RUN prepare-tool all


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
RUN install-tool java 25.0.5+100000002.0.LTS

# renovate: datasource=gradle-version
RUN install-tool gradle 9.9.2


# renovate: datasource=github-releases packageName=containerbase/erlang-prebuild versioning=semver-extended
RUN install-tool erlang 28.5.0.9

# renovate: datasource=github-releases packageName=elixir-lang/elixir
RUN install-tool elixir v1.20.5


# renovate: datasource=github-releases packageName=containerbase/php-prebuild
RUN install-tool php 8.5.13

# renovate: datasource=github-releases packageName=containerbase/composer-prebuild
RUN install-tool composer 2.11.3


# renovate: datasource=golang-version
RUN install-tool golang 1.27.4


# renovate: datasource=github-releases packageName=containerbase/python-prebuild
RUN install-tool python 3.14.10

# renovate: datasource=pypi
RUN install-tool conan 2.34.0

# renovate: datasource=pypi
RUN install-tool copier 9.19.1

# renovate: datasource=pypi
RUN install-tool hashin 1.0.5

# renovate: datasource=pypi
RUN install-tool pdm 2.29.7

# renovate: datasource=pypi
RUN install-tool pip-tools 7.7.0

# renovate: datasource=pypi
RUN install-tool pipenv 2026.12.0

# renovate: datasource=pypi
RUN install-tool poetry 2.5.2

# renovate: datasource=pypi
RUN install-tool uv 0.13.10


# renovate: datasource=docker
RUN install-tool rust 1.100.0


# renovate: datasource=github-releases packageName=containerbase/ruby-prebuild
RUN install-tool ruby 4.0.10

# renovate: datasource=rubygems
RUN install-tool bundler 4.1.1

# renovate: datasource=rubygems
RUN install-tool cocoapods 1.17.0


# renovate: datasource=dotnet-version packageName=dotnet-sdk
RUN install-tool dotnet 10.0.404


# renovate: datasource=github-releases packageName=helm/helm
RUN install-tool helm v4.3.2


# renovate: datasource=github-releases packageName=containerbase/jb-prebuild versioning=semver-extended
RUN install-tool jb 0.6.0.2


# renovate: datasource=npm
RUN install-tool bun 1.4.4


# renovate: datasource=github-releases packageName=containerbase/nix-prebuild
RUN install-tool nix 2.36.0


# renovate: datasource=github-releases packageName=jetify-com/devbox
RUN install-tool devbox 0.23.0


# renovate: datasource=github-releases packageName=bazelbuild/bazelisk
RUN install-tool bazelisk v1.30.0


# renovate: datasource=github-releases packageName=containerbase/node-prebuild versioning=node
RUN install-tool node 24.22.3

# renovate: datasource=npm
RUN install-tool pnpm 10.34.9

# renovate: datasource=npm packageName=@yarnpkg/cli-dist
RUN install-tool yarn 4.18.1


# renovate: datasource=dart-version
RUN install-tool dart 3.14.1

# renovate: datasource=github-releases packageName=containerbase/flutter-prebuild
RUN install-tool flutter 3.50.1

# renovate: datasource=github-releases packageName=carvel-dev/vendir
RUN install-tool vendir v0.47.0

# renovate: datasource=github-releases packageName=jdx/mise
RUN install-tool mise v2026.11.14

# --------------------------------------
# final image
# --------------------------------------
FROM ${BASE_IMAGE_TYPE}-base

ARG BASE_IMAGE_VERSION

LABEL \
  org.opencontainers.image.version="${BASE_IMAGE_VERSION}"

