# Release model (canonical)

**Foundation**

```text
Cheap proves mergeability.
Release PR proves shipability.
Tag publishes.
```

## Default flow (simple — required)

```text
feature/* ──PR──► main          quality only (cheap)
release/x.y.z ──PR──► main      quality + release_targets builds
     │
     ▼ merge
tag vX.Y.Z on merge commit
     │
     ▼
build (release_targets) → GitHub Release → deploy/publish
```

### Rules

1. **No permanent `dev` branch.**
2. Feature PRs: cheap CI only (`quality`). Empty `pr_builds`.
3. **Release PR** owns version bump + CHANGELOG **before** merge.
4. Tag **only after** Release PR merges (never before).
5. Tag workflow **rebuilds** then publishes. Do **not** require cross-run artifact reuse.
6. Within the **tag workflow run**: build once → deploy/release jobs download those artifacts (same run only).

### Why rebuild on tag (not promote Release PR artifacts)

- Artifacts expire.
- Cross-workflow lookup is fragile and hard to debug.
- Releases are infrequent — one extra build is acceptable.
- Simpler platform = easier maintenance across many repos.

Artifact promotion across runs = **optional later optimization**, not core architecture.

## Cost (honest)

Each ship may pay **two** expensive build passes:

1. Release PR (prove shipability / required checks)
2. Tag (produce publish bits)

That is intentional. Feature PRs stay cheap.

## platform-ci wiring

| Event | Call |
|-------|------|
| PR → main (feature) | `quality` only |
| PR → main (`release/**`) | `quality` + `build` (`trigger: release` or path-gated caller) |
| Tag `v*` | `build` (`trigger: release`) → `release` / deploy / pub in **same run** |

Consumer defaults: `pr_builds: []`, `main_builds: []`, `release_targets: [...]` per product.

## Anti-patterns

- Full matrix on every feature PR
- Permanent `dev` for solo
- Tag before version/changelog lands on main
- Version bump bot-commit straight to protected main
- Making cross-run artifact reuse mandatory in platform-ci
