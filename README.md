# platform-ci

Reusable GitHub Actions platform for Flutter / Dart repos.

**Goals:** free-tier minutes · solo/small team · config-driven · Linux-first · build once.

Consumers edit `ci/project.yaml`. Workflows stay thin callers.

## Quick start (consumer repo)

1. Add `ci/project.yaml` (see [`examples/`](examples/)).
2. Add caller workflow:

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
    uses: <OWNER>/platform-ci/.github/workflows/quality.yml@v1
    with:
      config_path: ci/project.yaml
```

3. Pin a release tag (`@v1` or `@v1.0.0`).

## Layout

| Path | Role |
|---|---|
| [`schema/project.schema.json`](schema/project.schema.json) | Config contract |
| [`.github/actions/`](.github/actions/) | Composite setup / I/O |
| [`.github/workflows/`](.github/workflows/) | Reusable workflows |
| [`examples/`](examples/) | Sample `ci/project.yaml` files |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Design rules |

## Workflows

| Workflow | Status | Purpose |
|---|---|---|
| `quality.yml` | **ready** | format + analyze + test |
| `build.yml` | stub | platform artifacts |
| `deploy.yml` | stub | Pages / Firebase from artifact |
| `release.yml` | stub | GitHub Release (+ optional pub.dev) |
| `maintain.yml` | stub | weekly chores |

## Versioning

- Semver tags: `v1.0.0`, moving major alias `v1`
- Breaking schema → `schema: 2` + workflow `@v2`

## Local checks (recommended)

Run format/analyze on changed paths before push (lefthook / pre-commit). CI is second opinion.
