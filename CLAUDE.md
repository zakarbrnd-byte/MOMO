# CLAUDE.md

Guidance for Cursor agents and contributors working on MOMO.

## Product

**MOMO** — community app for Korean mothers in the US.

**MVP goal:** Help moms discover and create local playdates and share parenting-related posts.

Version: MVP 0.1

## Core principle

Everything is a Card.

Card types only:

1. Playdate Card
2. Post Card

## Navigation

Bottom tabs: **Home** · **Create** · **Profile**

## Implemented screens

- Home Feed (mock Playdate + Post cards → detail)
- Create Selection → Create Playdate / Create Post
- Playdate Detail / Post Detail
- Profile (mock placeholder)

## Rules

- Use mock / local data first.
- No backend until Phase 4.
- Do not over-engineer.
- Every feature must help moms connect offline.
- Stay inside MVP scope (see `MVP_SPEC.md`).
- **Git Flow:** branch from `develop`, PR into `develop`, never force-push `main`/`develop`.
- **CI:** keep `flutter analyze`, `flutter test`, and web build green.
- **Parallel agents:** follow `docs/AI_AGENTS.md` folder ownership.

## Out of scope (do not add)

Business listings, marketplace, chat, payments, comments, photos, search, notifications, complex matching.

## Canonical docs

| Doc | Use for |
|-----|---------|
| `README.md` | Overview, run, status, deploy URLs |
| `CONTRIBUTING.md` | PR / commit / branch rules |
| `MVP_SPEC.md` | Scope in / out |
| `DEVELOPMENT_PLAN.md` | Phases |
| `ARCHITECTURE.md` | Code structure + data flow |
| `docs/ARCHITECTURE_FREEZE.md` | Frozen baseline — do not break |
| `docs/AI_AGENTS.md` | Multi-agent parallel work |
| `docs/cicd/README.md` | CI/CD pipelines |
| `PROJECT_CONTEXT.md` | Short current snapshot |

## Current gap for next work

Phase 3.4 architecture freeze is complete. Next is Phase 3.5 UI/UX validation (layout/visual only). Do not expand architecture or add backend without an approved issue.
