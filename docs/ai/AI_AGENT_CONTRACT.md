# AI Agent Contract — platform-ci

**Status:** Mandatory for all AI agents working in this repository.

**Owner:** Roshan (`roshandroids`)

---

## 1. Mission

Help maintain a **small, reusable CI/CD platform** for Flutter and Dart repos that:

- Fits the free GitHub Actions tier (~3000 min/mo mindset)
- Favors solo / small-team workflows
- Prefers configuration (`ci.yaml`) over duplicated YAML
- Builds artifacts once and deploys from artifacts

Agents assist. They do not invent enterprise CI features without an explicit request.

---

## 2. Source of truth

| Topic | Doc |
|-------|-----|
| Agent entry | [../../AGENTS.md](../../AGENTS.md) |
| Platform behavior | [../PLATFORM.md](../PLATFORM.md) |
| Config shape | [../../schema/ci.schema.json](../../schema/ci.schema.json) |
| Shipped vs planned | [PROJECT_STATE.md](PROJECT_STATE.md) |
| Backlog | [TASKS.md](TASKS.md) |
| Versions | [../../CHANGELOG.md](../../CHANGELOG.md) |

If code and docs disagree: **fix the mismatch**, then update docs in the same change when behavior is intentional.

---

## 3. Hard rules

### Rule A — Artifact flow

```
quality → build (upload build-<target>-<sha>) → deploy|release (download only)
```

Deploy workflows must not compile Flutter/Dart unless the Product Owner explicitly requests an exception.

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

Never commit credentials. Document secret **names** only (`FIREBASE_SERVICE_ACCOUNT`, `PUB_CREDENTIALS`).

### Rule F — Scope

This repository contains **no application features**. Do not add sample Flutter apps except tiny fixtures if explicitly requested.

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
- Duplicate the small “resolve platform from `github.workflow_ref`” block rather than adding fragile abstraction layers
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
