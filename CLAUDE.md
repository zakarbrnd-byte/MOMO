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
- No backend until Phase 3.
- Do not over-engineer.
- Every feature must help moms connect offline.
- Stay inside MVP scope (see `MVP_SPEC.md`).

## Out of scope (do not add)

Business listings, marketplace, chat, payments, comments, photos, search, notifications, complex matching.

## Canonical docs

| Doc | Use for |
|-----|---------|
| `README.md` | Overview, run, status |
| `MVP_SPEC.md` | Scope in / out |
| `DEVELOPMENT_PLAN.md` | Phases |
| `ARCHITECTURE.md` | Code structure + data flow |
| `PROJECT_CONTEXT.md` | Short current snapshot |

## Current gap for next work

Create Save/Post does not update the Home feed. Riverpod is wired at app root but feature providers are not implemented yet. Prefer Phase 2 local-state work over new product surfaces.
