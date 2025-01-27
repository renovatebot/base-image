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

variable "UID" {
  default = ""
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

target "slim" {
  inherits = ["settings"]
  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/${FILE}",
    "type=registry,ref=ghcr.io/${OWNER}/${FILE}:${TAG}",
    "type=registry,ref=ghcr.io/${OWNER}/docker-build-cache:${FILE}-slim",
    notequal("", UID) ? "ttl.sh/${UID}/amd64/slim:1d": "",
    notequal("", UID) ? "ttl.sh/${UID}/arm64/slim:1d": "",
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
    notequal("", UID) ? "ttl.sh/${UID}/amd64/full:1d": "",
    notequal("", UID) ? "ttl.sh/${UID}/arm64/full:1d": "",
  ]
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
    notequal("", UID) ? "ttl.sh/${UID}/amd64/${tgt}:1d": "",
    notequal("", UID) ? "ttl.sh/${UID}/arm64/${tgt}:1d": "",
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
  inherits = ["${tgt}", "cache"]
  tags = [
    "ghcr.io/${OWNER}/docker-build-cache:${FILE}-${tgt}",
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

target "ttl" {
  name = "ttl-${tgt}"
  matrix = {
    tgt = ["slim", "full"]
  }
  inherits = ["base-${tgt}", "cache"]
  tags = [
    and(notequal("", UID), notequal("", ARCH)) ? "ttl.sh/${UID}/${ARCH}/${tgt}:1d": "",
  ]
  target = "${tgt}-base"
}

