# Playground Showcase Host Application Onboarding Guide

> This guide is for AI coding agents and developers onboarding a private host application to the shared Playground Showcase publishing pipeline provided by platform-ci.

This document is self-contained. You should not need any other platform-ci file open to complete onboarding — though [`docs/SHOWCASE.md`](SHOWCASE.md) is the implementation-facing reference if you want the full mechanism (validation internals, workflow YAML, isolation guarantees).

**platform-ci is the sole publisher.** If you are working inside a private host repository, this guide tells you exactly what to add there and nothing more. You do not touch `rsprojects-showcase` directly, and you do not build a second publishing path.

---

## 1. Architecture

```
Private host application
        ↓
platform-ci
        ↓
Flutter Web playground build
        ↓
artifact validation
        ↓
showcase.json
        ↓
roshandroids/rsprojects-showcase/generated/<id>/
        ↓
GitHub Pages
```

- The **host application** owns the playground source (an example/demo Flutter app that can build for web).
- **platform-ci** owns build + publish orchestration: quality gate, `flutter build web --release`, artifact validation, `generated/<id>/showcase.json` metadata, and the push into the showcase repo.
- **`rsprojects-showcase`** owns public hosting and the catalog: it serves `generated/<id>/` via GitHub Pages and lists the playground in its own registry once a real artifact exists.
- **platform-ci is the only publisher.** The host application must not implement another publisher (a second `gh-pages` deploy, a hand-rolled push to `rsprojects-showcase`, or any workflow that writes to that repo directly).

## 2. Prerequisites

Before enabling showcase publishing, the host repository needs:

- A suitable Flutter playground/example application that builds for web — see [Section 3](#3-discover-the-playground).
- platform-ci already integrated (`ci.yaml` present, using platform-ci's reusable workflows).
- A release/tag flow the platform can hook into (platform-ci's standard `push: tags: v*` model — see [`docs/RELEASE.md`](RELEASE.md)) or willingness to publish via `workflow_dispatch`.
- GitHub Actions enabled on the repository.
- Ability to add a repository secret (`SHOWCASE_PUSH_TOKEN` — see [Section 6](#6-github-secret)).

**Repositories without a meaningful playground should not invent one solely for showcase publishing.** If there is no real public-facing demo app, stop here and report `Not eligible` (see [Section 14](#14-final-ai-agent-report)) rather than fabricating one.

## 3. Discover the Playground

Inspect these locations, in order, for a Flutter app that is meaningfully a public demo/playground (not the host's private production app, not a unit-test fixture):

```
example/
examples/
apps/
demo/
playground/
showcase/
```

For each candidate, inspect:

- `pubspec.yaml` — is it a Flutter application (not a package/plugin) with `web` support?
- `README.md` — does it describe itself as a demo, playground, or example?
- `.github/workflows/` — does it already build/deploy this app anywhere?
- `ci.yaml` — does platform-ci already reference this path (`paths:`, `melos` filter, etc.)?

You must determine the actual public demo application before touching configuration. Do not guess from the directory name alone — open the app and confirm it is something worth showing publicly.

**If multiple examples exist:**

- Prefer one product-level playground over several fragment demos.
- Do not create multiple showcase IDs for the same product unless the applications are genuinely independent products (different names, different audiences, different lifecycles). A "kitchen sink" example and a "minimal" example of the same product are not independent products.

## 4. Choose Showcase ID

The id is validated by both [`schema/ci.schema.json`](../schema/ci.schema.json) (`^[a-z0-9]+(?:-[a-z0-9]+)*$`) and [`showcase-validate`](../.github/actions/showcase-validate/action.yml). Rules:

- lowercase
- kebab-case
- stable
- unique (across all repos publishing to `rsprojects-showcase`)
- product-level (names the product, not a build variant)
- no underscores
- no slash
- no dots
- not `.git`
- not `.github`
- no leading or trailing hyphens

**Valid:**

```
document-platform
hcm-requisitions
ai-tray
```

**Rejected:**

```
DocumentPlatform        # not kebab-case
document_platform       # underscore
document/platform       # slash
document.platform       # dot
.git                    # reserved
-document-platform      # leading hyphen
document-platform-      # trailing hyphen
```

**Changing the id later creates a different public playground path** (`generated/<old-id>/` is orphaned, `generated/<new-id>/` starts from `pending`). Treat the id as effectively permanent once published; avoid renaming it unless you are intentionally migrating the deployment and are prepared to handle the orphaned path in `rsprojects-showcase`.

## 5. Add Configuration

Add to the host repository's `ci.yaml`:

```yaml
deploy:
  showcase:
    enabled: true
    id: document-platform
```

That is the **entire** consumer contract. Only `enabled` and `id` are valid fields — the schema has `additionalProperties: false` on `deploy.showcase`, so anything else fails config parsing, not just documentation review.

**This is INVALID — do not write this:**

```yaml
deploy:
  showcase:
    enabled: true
    id: document-platform
    repository: roshandroids/rsprojects-showcase        # ✗ forbidden
    path: generated/document-platform                    # ✗ forbidden
    base_href: /rsprojects-showcase/generated/document-platform/  # ✗ forbidden
```

Why these are forbidden: destination repository, destination path, and base-href are **computed by platform-ci**, not chosen per consumer. This keeps every publisher writing to the same fixed, predictable location (`generated/<id>/`) and prevents a misconfigured host app from publishing outside its own directory or to the wrong repository. Adding any of these three fields is a validation error at parse time (`read-config` explicitly rejects the legacy field names), not merely a style violation.

You also need the workflow that calls platform-ci. Copy [`templates/consumer-deploy-showcase.yml`](../templates/consumer-deploy-showcase.yml) into the host repo as `.github/workflows/deploy-showcase.yml`. Do not hand-write this file — copy it verbatim (only the `@v1` pin may need adjusting if the host pins a different platform-ci version).

## 6. GitHub Secret

Required: `SHOWCASE_PUSH_TOKEN`.

- Add it under the host repository's **Settings → Secrets and variables → Actions**.
- Must be a **fine-grained personal access token**.
- Repository access scoped to **only** `roshandroids/rsprojects-showcase` — no other repository.
- Permission: **Contents: Read and write**. Nothing broader.
- **No classic PAT.**
- Never commit it.
- Never put it in `.env`.
- Never put it in source code.
- Never print it in logs, echo it, or pass it to a step that isn't the checkout/push step that needs it.

This guide does not include a real token value, and you should never generate, request, or paste one into chat, a file, or a commit. The token is created and added to the secret store by a human with access to that GitHub organization/repository.

## 7. Remove Duplicate Publishers

Search the host repository for any existing workflow that independently publishes the same playground:

```
showcase
demo
github pages
gh-pages
deploy-demo
deploy-showcase
publish-demo
SHOWCASE_DEPLOY_TOKEN
SHOWCASE_PUSH_TOKEN
rsprojects-showcase
project_showcase
```

If a match points at the **same playground** you are onboarding, it is a duplicate publisher. Target architecture:

```
host app
    ↓
platform-ci
    ↓
rsprojects-showcase
```

There must be exactly one path from host app to `rsprojects-showcase`, and it must go through platform-ci. Remove the duplicate workflow (and its now-unused secret, if that secret is used nowhere else).

**Do not remove unrelated production deployments.** A hit on `deploy-pages` or `gh-pages` that deploys the host app's own production site (not this playground, not to `rsprojects-showcase`) is not a duplicate — leave it alone. Also note: `project_showcase` (no `rsprojects-` prefix, no `roshandroids/` owner) is not a real repository — if you find it referenced anywhere, it is stale/incorrect documentation from before this architecture was locked, not a second publisher to preserve.

## 8. Flutter Web Build

The playground must successfully build for web using the host repo's existing tooling:

```bash
fvm flutter build web --release
```

or:

```bash
flutter build web --release
```

**Do not hard-code the showcase base href in the host application.** platform-ci computes and passes `--base-href /rsprojects-showcase/generated/<id>/` when it builds for publishing. The host app's `web/index.html` only needs to keep the Flutter-default placeholder:

```html
<base href="$FLUTTER_BASE_HREF">
```

The resulting artifact (`build/web/`) must contain:

```
index.html
flutter.js  (or flutter_bootstrap.js)
assets/
```

and must **not** contain private source artifacts — platform-ci's own build step rejects the publish if any of these are found under `build/web`:

```
lib/
test/
tests/
pubspec.yaml
.git/
.github/
.env / *.env
*.pem
*.key
```

If your build somehow produces one of these under `build/web` (e.g. a custom `web/` asset that shadows a reserved name), fix the build — do not try to work around the check.

## 9. Release Flow

```
release/tag
    ↓
platform-ci
    ↓
quality checks
    ↓
Flutter Web build
    ↓
artifact validation
    ↓
publish
    ↓
rsprojects-showcase
    ↓
GitHub Pages
```

`deploy-showcase.yml` runs `quality.yml` first — the publish only starts if format/analyze/test pass. **Do not create a custom showcase publishing workflow.** The copied consumer template (Section 5) triggers on tag push (`v*`) and `workflow_dispatch`; that is the entire trigger surface you need.

## 10. Metadata

platform-ci generates `generated/<id>/showcase.json` (id, version, commit, deployedAt) as part of the publish step. **The host application must not create its own metadata format** or write anything to that path itself — the exact metadata contract is platform-owned and may change without a host-side migration if it stays internal to platform-ci and `rsprojects-showcase`.

## 11. Catalog / Registry

`assets/generated/registry.json` is owned and generated by `rsprojects-showcase` (from its own `content/projects/<id>/metadata.json`, a separate step from anything in this guide). The host application does not directly edit that registry — it lives in a different repository entirely.

The playground shows as `pending` in that catalog until its first artifact is actually published to `generated/<id>/`, and becomes `deployed` once the artifact exists. This is computed, not something you set — publishing a real build (Sections 8–9) is what flips it.

## 12. AI Agent Procedure

1. Inspect repository.
2. Determine project type (app / package / melos workspace).
3. Find the playground (Section 3).
4. Determine whether it is suitable for public showcase (Section 2's eligibility bar).
5. Choose a stable, unique id (Section 4).
6. Inspect existing CI for anything that already publishes this playground (Section 7).
7. Add `deploy.showcase.enabled: true` to `ci.yaml`.
8. Add `deploy.showcase.id: <id>` to `ci.yaml`.
9. Remove the duplicate showcase publisher if one was found in step 6.
10. Verify the `SHOWCASE_PUSH_TOKEN` secret requirement is documented for the human to add (Section 6) — do not attempt to create or fetch the token yourself.
11. Build Flutter Web for the playground and confirm it succeeds.
12. Run `flutter analyze` (or the host's existing analyze step).
13. Run `flutter test` (or the host's existing test step).
14. Review `git diff` — confirm only the intended files changed.
15. Do not commit automatically unless the user explicitly asks.
16. Report changes and remaining manual setup using the format in Section 14.

## 13. Validation Checklist

- [ ] playground identified
- [ ] showcase ID valid
- [ ] showcase ID unique
- [ ] `enabled` configured
- [ ] only `enabled` + `id` configured
- [ ] no `repository`/`path`/`base_href`
- [ ] no duplicate publisher
- [ ] `SHOWCASE_PUSH_TOKEN` documented (not created/fetched by the agent)
- [ ] Flutter Web build succeeds
- [ ] `index.html` exists
- [ ] Flutter bootstrap (`flutter.js` or `flutter_bootstrap.js`) exists
- [ ] `assets/` exists
- [ ] private source not included in the build output
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] unrelated code unchanged

## 14. Final AI Agent Report

Report using exactly this format:

```
## Playground Showcase Onboarding

Repository:
<repository>

Status:
Enabled / Not eligible / Blocked

Playground:
<path>

Showcase ID:
<id>

Configuration:
<file>

Duplicate publisher:
None / Removed: <workflow>

Web build:
PASS / FAIL

Analyze:
PASS / FAIL

Tests:
PASS / FAIL

Required secret:
SHOWCASE_PUSH_TOKEN

Manual setup:
<items>

Files changed:
<files>

Notes:
<remaining issues>
```

---

> **The Playground Showcase consumer contract is intentionally minimal.** Host applications configure only `deploy.showcase.enabled` and `deploy.showcase.id`. Do not add destination repository, destination path, or base-href configuration to host applications without a new architecture decision/ADR.
