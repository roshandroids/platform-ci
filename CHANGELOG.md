# Changelog

## 1.1.5

### Fixed

- `deploy-web-demos` skips manifest entries with `available: false`

## 1.1.4

### Fixed

- Melos `test` / `golden` steps use `melos exec --dir-exists=test` so tooling packages without `test/` (e.g. agentic `repo_tools`) do not fail quality


## 1.1.3

### Fixed

- Reusable workflows call composites via `uses: roshandroids/platform-ci/.github/actions/...@v1` instead of `github.workflow_ref` sparse-checkout (caller ref was checking out the consumer and breaking `action.yml`)

## 1.1.2

### Changed

- Canonical release model: Release PR proves shipability; tag rebuilds then publishes
- Cross-run artifact promotion = optional later, not core ([docs/RELEASE.md](docs/RELEASE.md))

## 1.1.1

### Changed

- Defaults are **opt-in**: empty `main_builds` / `release_targets`; quality-only consumer CI template
- Added `docs/OPT_IN.md` and `templates/consumer-ci-with-build.yml`

## 1.1.0

### Added

- Desktop/mobile builds: `macos`, `windows`, `linux`, `ios` (release-oriented)
- `node` + `node-setup` composite; `hooks.before_build`
- `build.<target>.script` / `package: zip` escape hatches
- Quality: `golden`, `integration`, `scripts[]`, coverage threshold fields
- `deploy-web-demos.yml` for `demos.json` multi-demo Pages
- Examples + `docs/COMPATIBILITY.md` for Document_Platform, AI_Tray, agentic_flutter_template

## 1.0.0

### Added

- Composite actions: `read-config`, `flutter-setup`, `melos-bootstrap`, `github-release`, `checkout-platform`
- Reusable workflows: `quality`, `build`, `release`, `deploy-firebase`, `deploy-pages`, `publish-pub`, `maintenance`
- `ci.yaml` schema, templates, examples
- `scripts/validate-local.sh`
- Platform self-test workflow + Dependabot (github-actions)
- AI-friendly docs: `AGENTS.md`, `docs/ai/*`
