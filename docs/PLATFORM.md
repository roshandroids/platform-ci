# platform-ci — Platform Guide

## Philosophy

1. **Opt-in** — platform offers many lanes; each repo enables only what it needs ([OPT_IN.md](OPT_IN.md)).
2. PR = quality flags you turned on. Builds only if build lists non-empty **and** caller includes `build.yml`.
3. Build each target **once per SHA**; deploy downloads artifacts.
4. macOS/Windows rare — release/tag, not every PR.
5. Policy in `ci.yaml`, not forked workflow YAML.

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
| cli | ubuntu | supported (`bin/*.dart` or script) |
| ios | macos | `--no-codesign` marker / prefer `script` for IPA |
| macos | macos | supported + optional zip |
| windows | windows | supported + optional zip |
| linux | ubuntu | supported + optional zip |

Custom: `build.<target>.script` must populate `dist/<target>/`.  
Node: `node.enabled` + `hooks.before_build`.  
Demos: `deploy-web-demos.yml`.

See [COMPATIBILITY.md](COMPATIBILITY.md).

## Consumer wiring

See [`templates/`](../templates/) and root [README](../README.md).

## Extending

1. Add target in `build.yml`
2. Extend `schema/ci.schema.json` + `read-config`
3. Bump major if inputs break
4. Update examples + CHANGELOG
