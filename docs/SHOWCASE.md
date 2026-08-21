# Showcase deployment

Publish **one project's** Flutter web release into `rsprojects-showcase/generated/<id>/`.

**platform-ci is the sole publisher.** `rsprojects-showcase` does not receive private-project artifacts and does not implement a second playground receiver. It hosts `generated/<id>/` and deploys them with the public showcase app on GitHub Pages.

Private source stays private. `platform-ci` builds and publishes.

```
PRIVATE PROJECT
       │  deploy.showcase.enabled + id
       ↓
platform-ci
       ├── validate configuration
       ├── quality
       ├── flutter build web --release
       ├── base href /rsprojects-showcase/generated/<id>/
       └── publish generated/<id>/ only
                ↓
rsprojects-showcase/generated/<id>/
                ↓
           GitHub Pages
```

## Locked Showcase Contract

Do **not** add consumer fields (`repository`, `path`, `base_href`) without a new architecture decision.

Consumer configuration:

```yaml
deploy:
  showcase:
    enabled: true
    id: document-platform
```

| | |
|--|--|
| Consumer fields | `deploy.showcase.enabled`, `deploy.showcase.id` |
| Public destination | `rsprojects-showcase/generated/<id>/` |
| Base href | `/rsprojects-showcase/generated/<id>/` |
| Metadata | `generated/<id>/showcase.json` |
| Registry (host repo) | `assets/generated/registry.json` |
| Secret | `SHOWCASE_PUSH_TOKEN` |

`id` is required when `enabled: true`. Omit `id` when disabled.

`id` must be kebab-case `[a-z0-9]+(-[a-z0-9]+)*` (no `/`, `.`, `..`, `_`, leading/trailing `-`).

## `showcase` vs `demos`

[`deploy.demos`](../.github/workflows/deploy-web-demos.yml) publishes **this repo's own** Pages site.

`deploy.showcase` publishes into the **shared** `rsprojects-showcase` repo. Both can be on at once.

## Enable

Schema: [`schema/ci.schema.json`](../schema/ci.schema.json). Parsed by [`read-config`](../.github/actions/read-config/action.yml).

Copy [`templates/consumer-deploy-showcase.yml`](../templates/consumer-deploy-showcase.yml) → `.github/workflows/deploy-showcase.yml`.

## Secret

`SHOWCASE_PUSH_TOKEN` — fine-grained PAT scoped **only** to `roshandroids/rsprojects-showcase`, **Contents: Read and write**. Never commit. Never print. No classic PAT. Default `GITHUB_TOKEN` cannot push to another repo.

Optional platform override: env `SHOWCASE_REPOSITORY` (`owner/repo`). Consumers do not set this in `ci.yaml`.

## Base href

Always `/rsprojects-showcase/generated/<id>/`. `web/index.html` must keep `<base href="$FLUTTER_BASE_HREF">`.

## Isolation

`showcase-sync` replaces only `generated/<id>/`. `git add generated/<id>` only. Push rebase retry. Concurrency group `showcase-generated-publish`, `cancel-in-progress: false`.

## Metadata

```json
{
  "id": "document-platform",
  "version": "1.2.0",
  "commit": "abc123",
  "deployedAt": "2026-08-21T12:00:00Z"
}
```
