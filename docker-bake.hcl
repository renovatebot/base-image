variable "OWNER" {
  default = "renovatebot"
}
variable "FILE" {
  default = "base-image"
}
variable "TAG" {
  default = "latest"
}
variable "BASE_IMAGE_VERSION" {
  default = "unknown"
}
variable "BASE_IMAGE_REVISION" {
  default = "unknown"
}

variable "APT_HTTP_PROXY" {
  default = ""
}

variable "CONTAINERBASE_DEBUG" {
  default = ""
}

variable "GITHUB_TOKEN" {
  default = ""
}

group "default" {
  targets = ["build-docker"]
}

group "push" {
  targets = ["push-ghcr", "push-cache"]
}


target "settings" {
  context = "."
  args = {
    APT_HTTP_PROXY      = "${APT_HTTP_PROXY}"
    CONTAINERBASE_DEBUG = "${CONTAINERBASE_DEBUG}"
    BASE_IMAGE_VERSION  = "${BASE_IMAGE_VERSION}"
    BASE_IMAGE_REVISION      = "${BASE_IMAGE_REVISION}"
    GITHUB_TOKEN        = "${GITHUB_TOKEN}"
  }
}

target "cache" {
  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}",
    "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-${TAG}",
  ]
}

target "push-cache" {
  inherits = ["settings", "cache"]
  output   = ["type=registry"]
  tags = [
    "ghcr.io/${OWNER}/docker-build-cache:${FILE}-${TAG}",
    "ghcr.io/${OWNER}/docker-build-cache:${FILE}",
  ]
  cache-to = ["type=inline,mode=max"]
}

target "build" {
  inherits = ["settings", "cache"]
  tags = [
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
    "${OWNER}/${FILE}:${TAG}",
    "${OWNER}/${FILE}"
  ]
}

target "build-docker" {
  inherits = ["settings", "cache"]
  output   = ["type=docker"]
  tags = [
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
    "${OWNER}/${FILE}:${TAG}",
    "${OWNER}/${FILE}",
    "containerbase/test"
  ]
}


target "push-ghcr" {
  inherits = ["settings", "cache"]
  output   = ["type=registry"]
  tags     = ["ghcr.io/${OWNER}/${FILE}", "ghcr.io/${OWNER}/${FILE}:${TAG}", ]
}

# target "push-hub" {
#   inherits = ["settings", "cache"]
#   output   = ["type=registry"]
#   tags     = ["${OWNER}/${FILE}", "${OWNER}/${FILE}:${TAG}"]
# }

