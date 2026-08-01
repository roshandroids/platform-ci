# platform-ci

Reusable GitHub Actions for Flutter / Dart repos.

**Goals:** free Actions tier · solo/small team · build once · `ci.yaml` over copy-paste.

Covers: apps · Melos monorepos · packages · CLI · web · Android · iOS · macOS · Windows · Linux · Firebase · Pages · multi-demo Pages · pub.dev.

## Quick start (consumer repo)

1. Copy [`templates/ci.yaml`](templates/ci.yaml) → `ci.yaml` (edit targets).
2. Copy [`templates/consumer-ci.yml`](templates/consumer-ci.yml) → `.github/workflows/ci.yml`.
3. Use `roshandroids/platform-ci` and pin `@v1`.

Optional templates: deploy-firebase · release · deploy-demos.

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

## License

MIT
