# AGENTS.md — platform-ci

> Mandatory entrypoint for AI coding agents (Cursor, Claude, Copilot, etc.).

## What this repo is

Reusable **GitHub Actions platform** for Flutter / Dart repositories. Not an application.

Consumers pin:

```yaml
uses: roshandroids/platform-ci/.github/workflows/quality.yml@v1
```

Product policy lives in the **consumer** `ci.yaml`. This repo owns workflows + composite actions + schema.

## Read first (in order)

1. [README.md](README.md) — human quick start
2. [docs/PLATFORM.md](docs/PLATFORM.md) — architecture rules
3. [docs/ai/AI_AGENT_CONTRACT.md](docs/ai/AI_AGENT_CONTRACT.md) — agent rules (this file summarizes; contract wins on conflict)
4. [docs/ai/PROJECT_STATE.md](docs/ai/PROJECT_STATE.md) — what is shipped / not shipped
5. [schema/ci.schema.json](schema/ci.schema.json) — config contract
6. [CHANGELOG.md](CHANGELOG.md) — version notes

## Non-negotiables

1. **Build once** — deploy/release must download artifacts; never re-run `flutter build` in deploy jobs.
2. **Config over forks** — extend `ci.yaml` / schema; do not tell consumers to copy-paste huge workflows.
3. **Minute thrift / opt-in** — default `pr_builds`/`main_builds`/`release_targets` empty; deploy/publish off; no macOS/Windows on PR. See [docs/OPT_IN.md](docs/OPT_IN.md). Capability in platform ≠ enabled for every consumer.
4. **Version API** — breaking workflow inputs or schema → new major (`v2`). Update CHANGELOG.
5. **Keep callables thin** — orchestration in workflows; setup in composite actions.
6. **Escape hatch** — product-specific gates via `quality.scripts` / `build.<target>.script` / `hooks.before_build`, not new workflows per app.
7. **No enterprise sprawl** — no self-hosted runners, no required coverage % in platform core.

## Where to change what

| Goal | Touch |
|------|--------|
| New `ci.yaml` field | `schema/ci.schema.json` + `read-config` + examples + COMPATIBILITY/PLATFORM |
| New quality step | `.github/workflows/quality.yml` (+ local `scripts/validate-local.sh` if shared) |
| New build target behavior | `.github/workflows/build.yml` + schema |
| New deploy sink | new `workflow_call` YAML + consumer template |
| Consumer mapping | `docs/COMPATIBILITY.md` + `examples/*` |

## Do not

- Hardcode app-specific project IDs or secrets in this repo
- Add macOS jobs for format/analyze/test
- Rebuild web inside `deploy-*` workflows
- Break `@v1` callers without a major bump
- Commit secrets, service-account JSON, or pub credentials

## Testing changes

1. Run platform self-test mentally: examples must still parse via `read-config`
2. Prefer PRs; `platform-self-test.yml` validates example configs
3. After merge to default branch: tag `v1.x.y` and move floating `v1` if compatible

## Consumer migration hint

Thin workflow + `ci.yaml` only. Replace `OWNER` with `roshandroids`. Pin `@v1`.
