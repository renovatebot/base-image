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
  targets = [
    "build",
    "build-full",
  ]
}

group "push" {
  targets = [
    "push",
    "push-full",
    "push-cache",
    "push-cache-full",
  ]
}


target "settings" {
  context = "."
  args = {
    APT_HTTP_PROXY      = "${APT_HTTP_PROXY}"
    CONTAINERBASE_DEBUG = "${CONTAINERBASE_DEBUG}"
    BASE_IMAGE_VERSION  = "${BASE_IMAGE_VERSION}"
    GITHUB_TOKEN        = "${GITHUB_TOKEN}"
  }
  tags = [
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
  ]
}

target "cache" {
  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}",
  ]
}

target "full" {
  args = {
    BASE_IMAGE_TYPE = "full"
  }
  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-full",
  ]
   tags = [
    "ghcr.io/${OWNER}/${FILE}:full",
    "ghcr.io/${OWNER}/${FILE}:${TAG}-full",
  ]
}

target "push-cache" {
  inherits = ["settings", "cache"]
  output   = ["type=registry"]
  tags = [
    "ghcr.io/${OWNER}/docker-build-cache:${FILE}",
  ]
  cache-to = ["type=inline,mode=max"]
}

target "push-cache-full" {
  inherits = ["push-cache", "full"]
  tags = [
    "ghcr.io/${OWNER}/docker-build-cache:${FILE}-full",
  ]
}

target "build" {
  inherits = ["settings", "cache"]
}

target "build-full" {
  inherits = ["build", "full"]

}

target "push" {
  inherits = ["settings", "cache"]
  output   = ["type=registry"]
}

target "push-full" {
  inherits = ["push", "full"]
}


