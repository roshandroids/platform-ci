# Project State — platform-ci

> AI agents: update this when shipping platform changes.

**Last updated:** 2026-08-01  
**Default branch:** `main`  
**Version:** `v1.1.0` intent / floating `@v1`  
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
| celpip-workspace | Not wired yet |
| Document_Platform | Example ready; migrate demos/quality next |
| AI_Tray | Example ready; desktop via release_targets |
| agentic_flutter_template | Example ready; should become template default |

---

## Operational notes

- Artifact: `build-<target>-<sha>`
- Pin `@v1`; tag `v1.1.0` after this ship
- Push workflows via SSH `roshandroids.github.com` (HTTPS token needs `workflow` scope)
