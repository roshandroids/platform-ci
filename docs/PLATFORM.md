# platform-ci — Platform Guide

## Philosophy

1. **Opt-in** — lanes exist; each repo enables only what it needs ([OPT_IN.md](OPT_IN.md)).
2. **Release model** — cheap mergeability / Release PR shipability / tag publish ([RELEASE.md](RELEASE.md)).
3. Feature PRs = `quality` only by default (empty build lists).
4. Expensive builds = Release PRs + tags (infrequent).
5. **Same-run** artifact handoff only: tag workflow builds once, then deploy/release downloads. Cross-run promotion is optional later — **not** required.
6. Policy in `ci.yaml`, not forked workflow YAML.

## Workflows

| Workflow | When to call |
|----------|----------------|
| `quality` | every PR → main |
| `build` | `release/**` PRs and/or tags (see RELEASE.md) |
| `deploy-firebase` / `deploy-pages` / `deploy-web-demos` | same run as `build` |
| `release` | on `v*` after `build` in same run |
| `publish-pub` | tag or manual |
| `maintenance` | weekly / manual |

## Artifact contract (same run)

```
build-<target>-<sha>
```

Deploy/release jobs in the **same workflow run** download these.  
Do not design core flows around fetching artifacts from a prior Release PR run.

## Platform resolve trick

Reusable workflows call composites with a pinned platform ref, e.g. `uses: roshandroids/platform-ci/.github/actions/read-config@v1`.

Do **not** resolve composites via `github.workflow_ref` + sparse checkout into `_platform_ci/` — `workflow_ref` is the **caller** workflow, so that pattern checks out the consumer repo and breaks `action.yml` lookup.

## Build support

| Target | Runner | Status |
|--------|--------|--------|
| web | ubuntu | supported |
| android | ubuntu | supported |
| cli | ubuntu | supported |
| ios | macos | prefer `script` for real IPA |
| macos / windows / linux | matching OS | supported + optional zip |

See [COMPATIBILITY.md](COMPATIBILITY.md) · [OPT_IN.md](OPT_IN.md) · [RELEASE.md](RELEASE.md).

## Consumer wiring

[`templates/`](../templates/) · [README](../README.md)
