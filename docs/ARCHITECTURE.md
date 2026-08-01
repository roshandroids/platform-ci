# platform-ci architecture

Opinionated CI/CD for Flutter/Dart. Solo / small team. ≤3000 Actions minutes/month private. Public Linux preferred.

## Hard rules

1. Linux default. macOS only for iOS / signed macOS / notarize.
2. PR = quality only (unless config opts into cheap web smoke).
3. Build once → artifact → deploy/release downloads.
4. One quality definition. Release calls it.
5. Repo holds thin caller + `ci/project.yaml`. Logic lives here.
6. Local hooks before CI.
7. No Melos/Firebase/Node unless config asks.

## Repos

| Repo | Role |
|---|---|
| `platform-ci` | reusable workflows, actions, schema |
| `flutter-template` | scaffolds callers + `ci/project.yaml` |
| consumer apps | product code + config only |

## Minimum workflows

`quality` · `build` · `deploy` · `release` · `maintain`

Config selects behavior. Do not fork per-product workflow names.

## Composite vs workflow

| Composite | Workflow |
|---|---|
| setup, parse config, publish I/O | job graph, matrix, path filters, quality commands |

## Event policy

| Event | Run |
|---|---|
| PR | quality (+ optional web smoke) |
| main | quality; optional build; optional deploy |
| tag | prefer manual release |
| manual | iOS, signed desktop, prod deploy, pub.dev |
| nightly | none |
| weekly | maintain only (thin) |

## Config

`ci/project.yaml` validated against `schema/project.schema.json`.

See examples under `examples/`.
