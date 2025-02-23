variable "OWNER" {
  default = "renovatebot"
}
variable "FILE" {
  default = "base-image"
}
variable "TAG" {
  default = "latest"
}
variable "CHANNEL" {
  default = ""
}
variable "BASE_IMAGE_VERSION" {
  default = "unknown"
}

variable "ARCH" {
  default = ""
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

target "base" {
  name = "base-${tgt}"
  matrix = {
    tgt = ["slim", "full"]
  }
  inherits = ["settings"]
  args = {
    BASE_IMAGE_TYPE = tgt
  }
  cache-from = [
    equal("slim", tgt) ? "type=registry,ref=ghcr.io/${OWNER}/${FILE}": "type=registry,ref=ghcr.io/${OWNER}/${FILE}:${tgt}",
    equal("slim", tgt) ? "type=registry,ref=ghcr.io/${OWNER}/${FILE}:${TAG}": "type=registry,ref=ghcr.io/${OWNER}/${FILE}:${TAG}-${tgt}",
    notequal("", CHANNEL) ? "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-${CHANNEL}-${tgt}" : "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-${tgt}",
    notequal("", CHANNEL) ? "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-${CHANNEL}-${tgt}-amd64" : "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-${tgt}-amd64",
    notequal("", CHANNEL) ? "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-${CHANNEL}-${tgt}-arm64" : "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-${tgt}-arm64",
  ]
}

target "publish" {
  output = ["type=registry"]
}

target "cache" {
  inherits = ["publish"]
  cache-to = ["type=inline,mode=max"]
}

target "push-cache" {
  name = "push-cache-${tgt}"
  matrix = {
    tgt = ["slim", "full"]
  }
  inherits = ["base-${tgt}", "cache"]
  tags = [
    notequal("", CHANNEL) ? "ghcr.io/${OWNER}/docker-build-cache:${FILE}-${CHANNEL}-${tgt}" : "ghcr.io/${OWNER}/docker-build-cache:${FILE}-${tgt}",
  ]
}

target "build-slim" {
  inherits = ["base-slim"]
  tags = [
    notequal("", CHANNEL) ? "ghcr.io/${OWNER}/${FILE}:${CHANNEL}" : "ghcr.io/${OWNER}/${FILE}",
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
  ]
}

target "build-full" {
  inherits = ["base-full"]
  tags = [
    notequal("", CHANNEL) ? "ghcr.io/${OWNER}/${FILE}:${CHANNEL}-full" : "ghcr.io/${OWNER}/${FILE}:full",
    "ghcr.io/${OWNER}/${FILE}:${TAG}-full",
  ]
}

target "push-slim" {
  inherits = ["build-slim", "publish"]
}

target "push-full" {
  inherits = ["build-full", "publish"]
}

target "build-cache" {
  name = "ttl-${tgt}"
  matrix = {
    tgt = ["slim", "full"]
  }
  inherits = ["base-${tgt}", "cache"]
  tags = [
    notequal("", ARCH) ? (notequal("", CHANNEL) ? "ghcr.io/${OWNER}/docker-build-cache:${FILE}-${CHANNEL}-${tgt}-${ARCH}" : "ghcr.io/${OWNER}/docker-build-cache:${FILE}-${tgt}-${ARCH}"): "",
  ]
  target = "${tgt}-base"
}

