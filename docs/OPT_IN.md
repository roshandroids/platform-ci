# Opt-in model — platform-ci never forces a full matrix

**Rule:** capability exists in the platform ≠ it runs for every repo.

Consumers enable only what they need via `ci.yaml` + thin caller workflows.

---

## What runs by default (minimal template)

| Lane | Default |
|------|---------|
| format / analyze / test | **on** (cheap, ubuntu) |
| coverage / golden / integration / scripts | **off** |
| Node / before_build | **off** |
| `pr_builds` / `main_builds` / `release_targets` | **[] empty** |
| Firebase / Pages / demos / pub | **enabled: false** |

Default caller: [`templates/consumer-ci.yml`](../templates/consumer-ci.yml) → **quality only**.

---

## How to enable pieces

| Want | Do |
|------|-----|
| Skip format or tests | `quality.format: false` / `quality.test: false` |
| Goldens | `quality.golden: true` |
| Integration | `quality.integration: true` |
| Extra repo scripts | `quality.scripts: ["./scripts/..."]` |
| Web build on PR | add `web` to `pr_builds` **and** use `consumer-ci-with-build.yml` |
| Web build on main | add `web` to `main_builds` + build caller |
| Desktop on tag only | `release_targets: [macos, windows]` + `consumer-release.yml` |
| Firebase | `deploy.firebase.enabled: true` + deploy template + secret |
| Pages | `deploy.pages.enabled: true` + deploy-pages caller |
| Multi-demo Pages | `deploy.demos.enabled: true` + demos caller |
| pub.dev | `publish.pub.enabled: true` + publish caller |

---

## Do not

- Copy every template workflow into every repo
- Put macos/windows/ios in `pr_builds` without a reason (minutes)
- Call `build.yml` when all build lists are empty (wastes a resolve job)
- Turn on demos/firebase/pages “just in case”

---

## Per-project examples

| Project | Typical enable set |
|---------|-------------------|
| Pure Dart package | quality only (± pub dry-run) |
| celpip web app | quality + `main_builds: [web]` + firebase |
| AI_Tray | quality + `release_targets: [macos, windows]` + node/hooks |
| Document_Platform | quality (+ scripts/golden) + demos on main + firebase on tag |
| agentic template | quality (+ golden/scripts) + web main + pages |

See [`COMPATIBILITY.md`](COMPATIBILITY.md) and [`examples/`](../examples/).
