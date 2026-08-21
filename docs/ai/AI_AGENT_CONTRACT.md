# AI Agent Contract — platform-ci

**Status:** Mandatory for all AI agents working in this repository.

**Owner:** Roshan (`roshandroids`)

---

## 1. Mission

Help maintain a **small, reusable CI/CD platform** for Flutter and Dart repos that:

- Fits the free GitHub Actions tier (~3000 min/mo mindset)
- Favors solo / small-team workflows
- Prefers configuration (`ci.yaml`) over duplicated YAML
- Follows [RELEASE.md](../RELEASE.md): cheap PRs, Release PR shipability, tag rebuild+publish

Agents assist. They do not invent enterprise CI features without an explicit request.

---

## 2. Source of truth

| Topic | Doc |
|-------|-----|
| Agent entry | [../../AGENTS.md](../../AGENTS.md) |
| Platform behavior | [../PLATFORM.md](../PLATFORM.md) |
| Release model | [../RELEASE.md](../RELEASE.md) |
| Opt-in | [../OPT_IN.md](../OPT_IN.md) |
| Config shape | [../../schema/ci.schema.json](../../schema/ci.schema.json) |
| Shipped vs planned | [PROJECT_STATE.md](PROJECT_STATE.md) |
| Backlog | [TASKS.md](TASKS.md) |
| Versions | [../../CHANGELOG.md](../../CHANGELOG.md) |

If code and docs disagree: **fix the mismatch**, then update docs in the same change when behavior is intentional.

---

## 3. Hard rules

### Rule A — Artifact flow (same run)

```
tag/dispatch run:  build (upload) → deploy|release (download only)
```

Within one workflow run, deploy must not recompile.  
**Across runs:** tag may rebuild even if a Release PR already built the same version — that is the default. Cross-run artifact promotion is optional later, not required. See [RELEASE.md](../RELEASE.md).

### Rule H — Release model

Cheap feature PRs. Release PR owns version + changelog and may run `release_targets` builds. Tag only after merge. Tag publishes (build → release/deploy). No permanent `dev` branch.

### Rule B — Schema first

New consumer-facing options require:

1. `schema/ci.schema.json` update
2. `read-config` output wiring
3. Example and/or template update
4. CHANGELOG entry

### Rule C — Compatibility

- Additive outputs / optional inputs: OK on `v1`
- Renamed/removed inputs, changed artifact names, changed default semantics that break callers: **`v2`**

### Rule D — Runners

- Default: `ubuntu-latest`
- macOS/Windows: only for targets that require them, and not on every PR by default
- v1 supported build targets: `web`, `android`, `cli`

### Rule E — Secrets

Never commit credentials. Document secret **names** only (`FIREBASE_SERVICE_ACCOUNT`, `PUB_CREDENTIALS`, `SHOWCASE_PUSH_TOKEN`).

### Rule F — Scope

This repository contains **no application features**. Do not add sample Flutter apps except tiny fixtures if explicitly requested.

---

### Rule G — Opt-in only

Never enable costly lanes by default in templates. Empty build lists and `enabled: false` deploy/publish are correct defaults. Document enables in [OPT_IN.md](../OPT_IN.md). Do not add a build/deploy job to the default consumer CI template.

---

## 4. Git & PR practice

- Prefer feature branches; keep PRs small and reviewable
- Do not force-push shared branches unless asked
- Tag releases: `v1.0.0` style; maintain floating major tag `v1` for compatible releases
- Update `PROJECT_STATE.md` / `TASKS.md` when shipping meaningful platform changes

---

## 5. Implementation style

- Prefer simple bash + Ruby YAML parse (already used) over new runtimes
- Prefer composite actions for repeated setup
- Prefer reusable `workflow_call` workflows for orchestration
- Call composites as `uses: roshandroids/platform-ci/.github/actions/<name>@v1` (same floating tag as the workflow). Never resolve via `github.workflow_ref` sparse-checkout — that points at the **caller** repo.
- Match existing file layout under `.github/actions` and `.github/workflows`

---

## 6. When uncertain

Ask the owner. Do not silently:

- Enable costly defaults (`pr_builds` full matrix, coverage gates, nightly desktop farms)
- Add self-hosted runners
- Change artifact naming (`build-<target>-<sha>`)

---

## 7. Done checklist (agent)

Before finishing a change:

- [ ] Schema / read-config / examples aligned (if config changed)
- [ ] Deploy path still download-only (if deploy touched)
- [ ] CHANGELOG updated for user-visible changes
- [ ] `AGENTS.md` / PLATFORM still accurate
- [ ] No secrets in the diff
