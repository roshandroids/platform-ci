# Project State — platform-ci

> AI agents: update this when shipping platform changes.

**Last updated:** 2026-08-21  
**Default branch:** `main`  
**Version:** `v1.2.0` intent / floating `@v1`  
**Remote:** https://github.com/roshandroids/platform-ci

---

## Purpose

Central reusable GitHub Actions platform for Flutter/Dart consumers across RSProjects: celpip, Document_Platform, AI_Tray, agentic_flutter_template, packages, CLI.

---

## Shipped

| Area | Status |
|------|--------|
| quality (+ golden/integration/scripts) | Shipped (v1.1) |
| build web/android/cli | Shipped (v1.0) |
| build ios/macos/windows/linux + zip/script | Shipped (v1.1) |
| node-setup + before_build | Shipped (v1.1) |
| deploy-firebase / pages / web-demos | Shipped |
| deploy-showcase (cross-repo public showcase publish) | Shipped (v1.2) |
| release / publish-pub / maintenance | Shipped |
| COMPATIBILITY + consumer examples | Shipped (v1.1) |
| AI docs | Shipped |

---

## Not shipped (explicit)

| Item | Notes |
|------|-------|
| Codesign / notarization / DMG / MSIX | Consumer scripts |
| Coverage % enforcement in platform | Use `quality.scripts` |
| Melos version bump automation | Consumer / template |
| Store publish | Out of scope |

---

## Consumers

| Repo | Status |
|------|--------|
| celpip-workspace | Draft PR migrate (`chore/migrate-platform-ci`) — web + Firebase |
| Document_Platform | Draft PR migrate — quality + web release + demos |
| AI_Tray | Draft PR migrate — quality + macOS/Windows release |
| agentic_flutter_template | Draft PR migrate — quality + web |

All use opt-in `ci.yaml`. Rulesets require `quality / Quality` (+ build web where configured).


---

## Operational notes

- Artifact: `build-<target>-<sha>`
- Pin `@v1`; tag `v1.1.0` after this ship
- Push workflows via SSH `roshandroids.github.com` (HTTPS token needs `workflow` scope)
