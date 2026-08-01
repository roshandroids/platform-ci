# platform-ci

Reusable GitHub Actions for Flutter / Dart repos.

**Goals:** free Actions tier · solo/small team · build once · `ci.yaml` over copy-paste.

## Quick start (consumer repo)

1. Copy [`templates/ci.yaml`](templates/ci.yaml) → `ci.yaml` (edit targets).
2. Copy [`templates/consumer-ci.yml`](templates/consumer-ci.yml) → `.github/workflows/ci.yml`.
3. Replace `OWNER/platform-ci` with `roshandroids/platform-ci` (or your fork).
4. After first release, pin `@v1`.

Optional templates:

- [`templates/consumer-deploy-firebase.yml`](templates/consumer-deploy-firebase.yml)
- [`templates/consumer-release.yml`](templates/consumer-release.yml)

Local gates (same as CI quality):

```bash
./scripts/validate-local.sh ci.yaml
```

## Callables (`@v1`)

| Workflow | Purpose |
|----------|---------|
| `quality.yml` | format · analyze · test |
| `build.yml` | build targets · upload `build-<target>-<sha>` |
| `release.yml` | GitHub Release from artifacts |
| `deploy-firebase.yml` | Hosting from web artifact (no rebuild) |
| `deploy-pages.yml` | GitHub Pages from artifact |
| `publish-pub.yml` | pub.dev publish / dry-run |
| `maintenance.yml` | weekly `pub outdated` when `ci.yaml` exists |

## Composite actions

| Action | Purpose |
|--------|---------|
| `read-config` | parse `ci.yaml` |
| `flutter-setup` | Flutter SDK + cache + pub get |
| `melos-bootstrap` | melos activate + bootstrap |
| `github-release` | `gh release create` + assets |
| `checkout-platform` | helper (workflows inline resolve too) |

## Config

Schema: [`schema/ci.schema.json`](schema/ci.schema.json)  
Examples: [`examples/`](examples/)  
Design notes: [`docs/PLATFORM.md`](docs/PLATFORM.md)

### AI agents

Start here: [`AGENTS.md`](AGENTS.md) → [`docs/ai/`](docs/ai/)

### Defaults that save minutes

- `pr_builds: []` — PRs run quality only
- Web/Android/CLI on ubuntu; iOS/desktop not in v1 build path
- Deploy never recompiles — downloads artifacts

## Versioning

- `@v1` floating major
- `@v1.0.0` immutable
- Breaking inputs/schema → `v2`

## License

MIT
