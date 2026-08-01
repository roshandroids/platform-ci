# Project State — platform-ci

> AI agents: update this when shipping platform changes.

**Last updated:** 2026-08-01  
**Default branch:** `main`  
**Version:** `v1.0.0` / floating `@v1`  
**Remote:** https://github.com/roshandroids/platform-ci

---

## Purpose

Central reusable GitHub Actions platform for Flutter/Dart consumers (apps, packages, Melos monorepos, CLI, Firebase Hosting, GitHub Pages, pub.dev).

---

## Shipped (v1.0.0)

| Area | Status |
|------|--------|
| `read-config` | Shipped |
| `flutter-setup` | Shipped |
| `melos-bootstrap` | Shipped |
| `github-release` | Shipped |
| `quality` workflow | Shipped |
| `build` workflow (`web`, `android`, `cli`) | Shipped |
| `release` workflow | Shipped |
| `deploy-firebase` | Shipped |
| `deploy-pages` | Shipped |
| `publish-pub` | Shipped |
| `maintenance` | Shipped |
| `platform-self-test` | Shipped |
| `ci.yaml` schema + templates + examples | Shipped |
| `scripts/validate-local.sh` | Shipped |
| AI docs (`AGENTS.md`, `docs/ai/*`) | Shipped |
| GitHub publish + tags `v1` / `v1.0.0` | Shipped |

---

## Not shipped (explicit)

| Item | Notes |
|------|-------|
| iOS / macOS / Windows / Linux desktop builds | Fail fast in `build.yml` with clear error |
| Store publish (Play / App Store) | Out of scope |
| Melos affected-graph | Out of scope until needed |
| Coverage % gate | Default off |
| Self-hosted runners | Not justified |

---

## Consumers

None wired yet. Intended first consumer: `celpip-workspace` (migrate later).

Use: `roshandroids/platform-ci/.github/workflows/*.yml@v1`

Note: legacy `master` branch may still exist from an earlier Phase 0 scaffold (`ci/project.yaml`). Prefer `main` + `@v1`.

---

## Operational notes

- Reusable workflows resolve this repo via `github.workflow_ref` into `_platform_ci/`
- Artifact contract: `build-<target>-<sha>`
- Dependabot: github-actions weekly
- Push workflows require SSH (`roshandroids.github.com`) or a token with `workflow` scope
