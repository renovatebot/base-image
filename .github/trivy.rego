package trivy

import rego.v1

default ignore := false

# kernel headers only, reports kernel CVEs which don't apply to containers
# https://github.com/containerbase/base/issues/7593
ignore if input.PkgName == "linux-libc-dev"
