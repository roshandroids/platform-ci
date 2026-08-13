# Contributing

Thanks for helping improve **platform-ci** — reusable GitHub Actions for Flutter / Dart.

## Before you start

1. Read [README.md](README.md) and [docs/PLATFORM.md](docs/PLATFORM.md).
2. Skim [docs/RELEASE.md](docs/RELEASE.md) and [docs/OPT_IN.md](docs/OPT_IN.md).
3. Agents: [AGENTS.md](AGENTS.md) → [docs/ai/AI_AGENT_CONTRACT.md](docs/ai/AI_AGENT_CONTRACT.md).

## Scope rules

- Prefer **config / schema** over forked workflow YAML.
- Keep feature PRs cheap: no macOS/Windows for format/analyze/test.
- Do not hardcode app IDs, secrets, or consumer project names in platform workflows.
- Breaking `ci.yaml` / workflow inputs → major bump (`v2`), not a silent `@v1` change.

## Local checks

```bash
./scripts/validate-local.sh examples/minimal.ci.yaml
# or any examples/*.ci.yaml / templates/ci.yaml
```

After changing schema or `read-config`, confirm examples still parse.

## Pull requests

1. One concern per PR when possible.
2. Update [schema/ci.schema.json](schema/ci.schema.json), examples, and docs when you add `ci.yaml` fields.
3. Note consumer impact in the PR body (`@v1` compatible? docs/COMPATIBILITY?).
4. Bump [CHANGELOG.md](CHANGELOG.md) for user-visible changes.

## Reporting bugs / ideas

Use GitHub Issues (templates provided). Include:

- platform ref (`@v1` / `@v1.x.y`)
- relevant `ci.yaml` snippet (redact secrets)
- workflow run link if public

## Security

See [SECURITY.md](SECURITY.md). Do not open public issues for secrets or exploit details.
