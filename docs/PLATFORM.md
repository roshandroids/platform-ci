# platform-ci — Platform Guide

## Philosophy

1. PR = quality. Builds only if `pr_builds` set.
2. Build each target **once per SHA**; deploy downloads artifacts.
3. macOS rare — not used for v1 supported targets (web/android/cli).
4. Policy in `ci.yaml`, not forked workflow YAML.

## Workflows

| Workflow | When to call |
|----------|----------------|
| `quality` | every PR + main |
| `build` | when targets non-empty for trigger |
| `deploy-firebase` / `deploy-pages` | after build, same run |
| `release` | on `v*` tags after build |
| `publish-pub` | tag or manual |
| `maintenance` | weekly / manual |

## Artifact contract

```
build-<target>-<sha>
```

Examples: `build-web-abc123`, `build-android-abc123`, `build-cli-abc123`.

Deploy/release **must** run in the **same workflow run** as `build` (Actions artifact scope).

## Platform resolve trick

Reusable workflows checkout this repo via `github.workflow_ref` into `_platform_ci/`, then `uses: ./_platform_ci/.github/actions/...`. Caller’s `uses: .../quality.yml@v1` pins matching actions automatically.

## v1 build support

| Target | Runner | Status |
|--------|--------|--------|
| web | ubuntu | supported |
| android | ubuntu | supported |
| cli | ubuntu | supported (`bin/*.dart`) |
| ios / macos / windows / linux | — | explicit fail (extend later) |

## Consumer wiring

See [`templates/`](../templates/) and root [README](../README.md).

## Extending

1. Add target in `build.yml`
2. Extend `schema/ci.schema.json` + `read-config`
3. Bump major if inputs break
4. Update examples + CHANGELOG
