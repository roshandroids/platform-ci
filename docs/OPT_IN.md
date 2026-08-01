# Opt-in model — platform-ci never forces a full matrix

**Rule:** capability exists ≠ it runs for every repo.

Canonical release flow: [RELEASE.md](RELEASE.md).

---

## Defaults (minimal template)

| Lane | Default |
|------|---------|
| format / analyze / test | **on** |
| coverage / golden / integration / scripts | **off** |
| Node / before_build | **off** |
| `pr_builds` / `main_builds` / `release_targets` | **[]** |
| Firebase / Pages / demos / pub | **off** |

Default caller: [`templates/consumer-ci.yml`](../templates/consumer-ci.yml) → **quality only**.

---

## Enable pieces

| Want | Do |
|------|-----|
| Toggle quality gates | `quality.*` booleans / `scripts` |
| Prove ship on Release PR | non-empty `release_targets` + build on `release/**` PRs |
| Publish on tag | tag workflow: `build` then `release`/deploy (**rebuild on tag**) |
| Continuous web preview (rare) | optional `pr_builds: [web]` — not default |
| Firebase / Pages / demos / pub | `deploy.*` / `publish.*` + matching thin workflow |

---

## Do not

- Expensive builds on every feature PR
- Permanent `dev` branch for solo
- Require cross-run artifact reuse
- Call `build.yml` when all target lists empty
- Enable demos/firebase/pages “just in case”

---

## Per-project (target end-state)

| Project | Feature PR | Release PR / tag |
|---------|------------|------------------|
| AI_Tray | quality | macos + windows |
| Document_Platform | quality | web (+ demos on main optional) |
| celpip | quality | web + firebase on tag/main deploy policy |
| agentic template | quality | web |
| MBO | quality (+ corpus/demo scripts) | human `workflow_dispatch` release (keep); demos Pages on main |

See [COMPATIBILITY.md](COMPATIBILITY.md) · [examples/](../examples/).
