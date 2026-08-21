# Compatibility — can Document_Platform / AI_Tray / agentic_flutter_template use platform-ci?

**Answer:** Yes — each repo opts into lanes via `ci.yaml`. Platform does **not** run the full matrix for every consumer. See [OPT_IN.md](OPT_IN.md).

| Repo | Fit | How |
|------|-----|-----|
| **Document_Platform** | Strong | `kind: melos` · `quality.scripts` for changelog/boundaries · `deploy.demos` + `deploy-web-demos.yml` · `deploy.showcase` + `deploy-showcase.yml` (public showcase repo, tag-triggered) · Firebase via `deploy-firebase` on tag (artifact) · keep local `scripts/release.sh` for SemVer if desired |
| **AI_Tray** | Strong after desktop | `paths: [ai_tray]` · `node.enabled` · `hooks.before_build` bridge · `release_targets: [macos, windows]` · `build.*.package: zip` or `script:` for custom names |
| **agentic_flutter_template** | Strong | Replace modular workflow copies with `quality` + optional `build` · goldens via `quality.golden` · boundaries via `quality.scripts` · Pages via `deploy.pages` · stop rebuilding web in deploy |
| **celpip-workspace** | Strong | Already matches web + Firebase pattern |

## Gaps closed in platform-ci v1.1

| Gap | Fix |
|-----|-----|
| Desktop builds unimplemented | `macos` / `windows` / `linux` / `ios` in `build.yml` |
| Node sidecar | `node` + `node-setup` + `hooks.before_build` |
| Custom packaging | `build.<target>.script` must fill `dist/<target>/` |
| Multi-demo Pages | `deploy-web-demos.yml` + `deploy.demos` |
| Cross-repo public showcase for private projects | `deploy-showcase.yml` + `deploy.showcase` ([SHOWCASE.md](SHOWCASE.md)) |
| Goldens / integration | `quality.golden` / `quality.integration` |
| Repo-specific gates | `quality.scripts[]` |
| Zip desktop artifacts | `build.<target>.package: zip` |

## Still consumer-owned (on purpose)

- Changelog / ADR / docs-validate wording
- Coverage % enforcement via consumer script (platform collects `--coverage` only)
- Codesign / notarization / DMG / MSIX
- Melos `version` bump UX (`melos version` local or template release.yml)
- Path-filter split jobs named Format/Analyze/Test (single Quality job is default; consumers may wrap)

## Example configs

- [`examples/document-platform.ci.yaml`](../examples/document-platform.ci.yaml)
- [`examples/ai-tray.ci.yaml`](../examples/ai-tray.ci.yaml)
- [`examples/agentic-flutter-template.ci.yaml`](../examples/agentic-flutter-template.ci.yaml)

## Migration order (recommended)

1. **celpip** — web/Firebase (simplest)
2. **agentic_flutter_template** — become the template that ships platform-ci callers
3. **Document_Platform** — demos + quality.scripts; keep release scripts initially
4. **AI_Tray** — last (desktop + bridge); keep zip naming via `script:` if needed

## Agent transcripts consulted

- Document_Platform: [c0d4f304](c0d4f304-e5ec-4542-b48b-f8f1ad98fa9e) CI audit
- agentic_flutter_template: [544ec4ce](544ec4ce-9227-4fea-819e-2602cc8d4a56) CI audit
- AI_Tray: [e5206481](e5206481-55b1-47ff-9dae-61966a4667fb) CI audit + platform design; [9b61a4a1](9b61a4a1-88d9-4895-8a6c-5c01549f6926) macOS minute burn
