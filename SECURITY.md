# Security Policy

## Supported versions

| Version | Supported |
|---------|-----------|
| `@v1` / `v1.x.y` | Yes |
| pre-`v1` / untagged main | Best effort |

## Reporting a vulnerability

Do **not** open a public GitHub issue for security problems.

Email **shrestharoshan776@gmail.com** with:

- description of the issue
- affected workflow / action / tag if known
- steps to reproduce (private gist OK)
- impact (secret leak, supply-chain, privilege escalation, etc.)

You should get an acknowledgment within a few days. Fixes ship via patch tag on `v1` when possible.

## Secrets in consumer repos

This platform never needs your production secrets checked into **this** repo. Keep Firebase / pub / signing credentials in the **consumer** GitHub Actions secrets only.
