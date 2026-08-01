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
3. [docs/RELEASE.md](docs/RELEASE.md) — release / tag model
4. [docs/ai/AI_AGENT_CONTRACT.md](docs/ai/AI_AGENT_CONTRACT.md) — agent rules (this file summarizes; contract wins on conflict)
5. [docs/ai/PROJECT_STATE.md](docs/ai/PROJECT_STATE.md) — what is shipped / not shipped
6. [schema/ci.schema.json](schema/ci.schema.json) — config contract
7. [CHANGELOG.md](CHANGELOG.md) — version notes

## Non-negotiables

1. **Release model** — cheap feature PRs; Release PR proves shipability; tag publishes. See [docs/RELEASE.md](docs/RELEASE.md). Tag workflow may **rebuild**; cross-run artifact reuse is optional, not required.
2. **Same-run handoff** — within a publish run, build once then deploy/release download artifacts. Never rebuild inside `deploy-*` after that run’s build.
3. **Config over forks** — extend `ci.yaml` / schema; no huge copy-paste workflows.
4. **Minute thrift / opt-in** — empty build lists by default; no macOS/Windows on feature PRs. [docs/OPT_IN.md](docs/OPT_IN.md).
5. **Version API** — breaking inputs/schema → `v2`.
6. **Escape hatch** — `quality.scripts` / `build.*.script` / `hooks.before_build`.
7. **No enterprise sprawl** — no self-hosted runners, no mandatory coverage %.

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
