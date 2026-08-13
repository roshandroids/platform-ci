# platform-ci

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/roshandroids/platform-ci)](https://github.com/roshandroids/platform-ci/releases)

Reusable GitHub Actions for Flutter / Dart repos.

**Goals:** free Actions tier · solo/small team · build once · `ci.yaml` over copy-paste.

Covers: apps · Melos monorepos · packages · CLI · web · Android · iOS · macOS · Windows · Linux · Firebase · Pages · multi-demo Pages · pub.dev.

## Quick start (consumer repo)

1. Copy [`templates/ci.yaml`](templates/ci.yaml) → `ci.yaml` (defaults = quality only).
2. Copy [`templates/consumer-ci.yml`](templates/consumer-ci.yml) → `.github/workflows/ci.yml`.
3. Pin `roshandroids/platform-ci@v1`.
4. **Opt in** builds/deploy/release only when needed — see [`docs/OPT_IN.md`](docs/OPT_IN.md) and [`docs/RELEASE.md`](docs/RELEASE.md).

Nothing outside `quality.format/analyze/test` runs unless you enable it and add the matching thin workflow.

Optional callers: [`consumer-ci-with-build.yml`](templates/consumer-ci-with-build.yml) · deploy-firebase · release · deploy-demos.

Local: `./scripts/validate-local.sh ci.yaml`

## Callables (`@v1`)

| Workflow | Purpose |
|----------|---------|
| `quality.yml` | format · analyze · test · optional golden/integration/scripts |
| `build.yml` | all targets · optional Node · before_build · zip · custom script |
| `release.yml` | GitHub Release from artifacts |
| `deploy-firebase.yml` | Hosting from web artifact |
| `deploy-pages.yml` | Pages from single artifact |
| `deploy-web-demos.yml` | Multi-demo site from `demos.json` |
| `publish-pub.yml` | pub.dev |
| `maintenance.yml` | weekly hygiene |

## Compatible consumers

See [`docs/COMPATIBILITY.md`](docs/COMPATIBILITY.md) for Document_Platform, AI_Tray, agentic_flutter_template, celpip.

## AI agents

Start: [`AGENTS.md`](AGENTS.md) → [`docs/ai/`](docs/ai/)

## Versioning

`@v1` floating · `@v1.x.y` immutable · breaking → `v2`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Conduct: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Security: [SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE) © Roshan Shrestha
