# `@renovatebot/base-image`

Metadata about the tools supported by the [Renovate base image](https://github.com/renovatebot/base-image).

The package is released together with the `ghcr.io/renovatebot/base-image` image and has the same version.
It re-exports [`@containerbase/base`](https://www.npmjs.com/package/@containerbase/base) at the Containerbase version the image is built from, so the tool list matches the tools that can be installed in that image.

```ts
import { tools, type ToolName } from '@renovatebot/base-image';
import { SupportedTools } from '@renovatebot/base-image/zod';
import pkg from '@renovatebot/base-image/package.json' with { type: 'json' };

pkg.version; // the base image version, eg. '13.110.2'
tools.composer; // { parent: 'php' }
```

See the [`@containerbase/base` readme](https://github.com/containerbase/base/tree/main/packages/base#readme) for the exported data.
