## Summary

<!-- What and why (not a file list). -->

## Type

- [ ] Fix
- [ ] Feature / schema
- [ ] Docs
- [ ] Chore / CI internals

## Checklist

- [ ] `ci.yaml` / schema / examples updated if needed
- [ ] Docs updated (`PLATFORM`, `OPT_IN`, `COMPATIBILITY`, `CHANGELOG` as relevant)
- [ ] Still `@v1`-compatible (or called out as breaking → `v2`)
- [ ] No secrets, app IDs, or consumer-specific hardcoding

## Test plan

- [ ] `./scripts/validate-local.sh` on touched examples / templates
- [ ] Mentally checked consumer wiring / self-test impact
