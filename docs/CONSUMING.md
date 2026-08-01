# Consuming platform-ci

## 1. Add config

Copy an example from `examples/<kind>/ci/project.yaml` into your repo as `ci/project.yaml`. Edit pins and flags.

## 2. Add caller workflow

```yaml
# .github/workflows/ci.yml
name: ci
on:
  pull_request:
  push:
    branches: [main]
concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
jobs:
  quality:
    uses: YOUR_USER/platform-ci/.github/workflows/quality.yml@v1
    with:
      config_path: ci/project.yaml
```

Replace `YOUR_USER`. Prefer tag `@v1.0.0` until platform stable, then `@v1`.

## 3. Private platform repo

If `platform-ci` is private, caller needs:

```yaml
jobs:
  quality:
    uses: YOUR_USER/platform-ci/.github/workflows/quality.yml@v1
    secrets: inherit
```

And org/user must allow access to the reusable workflow.

## 4. Do not copy workflow bodies

Change behavior via `ci/project.yaml` only. Open a PR on `platform-ci` for new capabilities.

## 5. Status

| Capability | Ready |
|---|---|
| Quality (format/analyze/test) | yes |
| Build artifacts | stub |
| Deploy Pages/Firebase | stub |
| Release / pub.dev | stub |
