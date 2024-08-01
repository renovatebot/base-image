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

group "default" {
  targets = [
    "build-slim",
    "build-full",
  ]
}

group "push" {
  targets = [
    "push-slim",
    "push-full",
    "push-cache-slim",
    "push-cache-full",
  ]
}


target "settings" {
  context = "."
  args = {
    APT_HTTP_PROXY      = "${APT_HTTP_PROXY}"
    CONTAINERBASE_DEBUG = "${CONTAINERBASE_DEBUG}"
    BASE_IMAGE_VERSION  = "${BASE_IMAGE_VERSION}"
  }
}

target "slim" {
  inherits = ["settings"]
  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/${FILE}",
    "type=registry,ref=ghcr.io/${OWNER}/${FILE}:${TAG}",
    "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}",
  ]
}

target "full" {
  inherits = ["settings"]
  args = {
    BASE_IMAGE_TYPE = "full"
  }
  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/${FILE}:full",
    "type=registry,ref=ghcr.io/${OWNER}/${FILE}:${TAG}-full",
    "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-full",
  ]
}

target "publish" {
  output = ["type=registry"]
}

target "cache" {
  inherits = ["publish"]
  cache-to = ["type=inline,mode=max"]
}

target "push-cache-slim" {
  inherits = ["slim", "cache"]
  tags = [
    "ghcr.io/${OWNER}/docker-build-cache:${FILE}",
  ]
}

target "push-cache-full" {
  inherits = ["full", "cache"]
  tags = [
    "ghcr.io/${OWNER}/docker-build-cache:${FILE}-full",
  ]
}

target "build-slim" {
  inherits = ["slim"]
  tags = [
    "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
  ]
}

target "build-full" {
  inherits = ["full"]
  tags = [
    "ghcr.io/${OWNER}/${FILE}:full",
    "ghcr.io/${OWNER}/${FILE}:${TAG}-full",
  ]

}

target "push-slim" {
  inherits = ["build-slim", "publish"]
}

target "push-full" {
  inherits = ["build-full", "publish"]
}


