# AI Agents — parallel development guide

MOMO is built by **multiple AI coding agents and humans at once**. This document minimizes merge conflicts and accidental architecture drift.

## Goals for agents

1. Ship small, reviewable PRs into `develop`
2. Touch the fewest shared files possible
3. Never weaken CI or deploy pipelines without an explicit DevOps task
4. Respect architecture freeze (`docs/ARCHITECTURE_FREEZE.md`)

## Branch naming

```
feature/<topic>                 # preferred
feature/<agent-id>-<topic>      # when two agents share a domain
hotfix/<topic>
release/x.y.z
```

Cursor cloud agents historically used `cursor/<topic>-8280`. That remains acceptable; still PR into **`develop`**.

## Folder ownership (soft locks)

| Area | Own when working on | Avoid unless tasked |
|------|---------------------|---------------------|
| `lib/features/home/` | Home feed UI | Create / Profile |
| `lib/features/create/` | Create flows | Home cards |
| `lib/features/detail/` | Detail / join UI | Feed providers |
| `lib/features/profile/` | Profile UI | Repositories |
| `lib/providers/` | State for your feature | Unrelated providers |
| `lib/repositories/`, `lib/data/`, `lib/dto/`, `lib/models/` | Backend-ready data work | Random renames |
| `lib/core/` | Design system / shared widgets | Drive-by refactors |
| `test/` | Tests for your change | Rewriting unrelated suites |
| `.github/workflows/` | Explicit CI/CD tasks only | “While I’m here” edits |
| `docs/cicd/` | DevOps documentation | Product copy |

**Rule:** If two agents need the same file, serialize: merge the first PR before starting the second, or split the file.

## Merge strategy for agents

1. Branch from latest `develop`
2. Implement + test
3. Rebase/merge `develop` just before PR
4. Squash-merge PR → `develop`
5. Delete the feature branch
6. Start the next task from updated `develop`

## Commit message convention

Conventional Commits only:

```
feat(home): show empty state when feed is idle
fix(join): disable button while mutation in flight
test(create): cover date validation
ci: fail analyze on infos
docs(agents): clarify folder ownership
```

## Review process

1. CI must be green (`CI` workflow)
2. PR Preview artifact should build (`PR Preview` workflow)
3. CODEOWNERS auto-requests review on sensitive paths
4. Human (or designated agent reviewer) checks freeze boundaries
5. Squash merge

## Conflict reduction checklist

- [ ] Did not reformat entire files
- [ ] Did not reorder imports repo-wide
- [ ] Did not bump Flutter/dependencies unless required
- [ ] Did not edit `pubspec.yaml` + feature code in the same PR if avoidable
- [ ] Added/updated tests next to the change
- [ ] Left unrelated TODOs alone

## What agents must not do

- Force-push to `main` or `develop`
- Skip hooks / delete workflows to “get green”
- Commit secrets
- Expand MVP scope into chat, payments, or backend without an approved issue
- Change Git Flow branch meanings without a DevOps PR
