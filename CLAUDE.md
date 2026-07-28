# CLAUDE.md

Guidance for Cursor agents and contributors working on MOMO.

## Product

**MOMO** — mobile community for Korean mothers in Southern California.

**MVP goal:** Help moms discover and create local playdates and share parenting-related community posts.

**Positioning:** Playdate-first Korean mom community — practical everyday topics (MissyUSA-inspired content usefulness), warm identity, clear event participation. Not a dense classic forum.

Version: MVP 0.1

## Core principle

Everything is a Card.

Card types only:

1. Playdate Card
2. Post Card

## Navigation

Bottom tabs: **홈** · **만들기** · **프로필**

(Do not add nonfunctional tabs.)

## Home hierarchy (Phase 3.5)

1. Playdate creation CTA
2. Upcoming / nearby playdates
3. Popular posts
4. Recent posts
5. Category discovery
6. Filtered feed (전체 / 플레이데이트 / 육아톡)

## Implemented screens

- Home Feed (playdate-first sections + filters + redesigned cards → detail)
- Create Selection → Create Playdate / Create Post
- Playdate Detail / Post Detail (engagement display-only)
- Profile (mock placeholder)

## Architecture

```
UI → Riverpod providers → Repository interfaces → Repository impls
  → Data sources → Mock data sources
```

- UI must not import mock data or call repositories/data sources directly
- Prefer existing providers; do not invent a second state pattern
- Architecture freeze: `docs/ARCHITECTURE_FREEZE.md`
- Domain / repository / DI changes require review

## Rules

- Use mock / local data first.
- No backend / Supabase until Phase 4.
- Do not over-engineer.
- Every feature must help moms connect offline.
- Stay inside MVP scope (see `MVP_SPEC.md`).
- Engagement metrics (views/comments/likes) are display-only unless interactivity is already implemented.

## Out of scope (do not add)

Business listings, marketplace, chat, payments, interactive comments/likes, photos, search backend, notifications backend, complex matching.

## Canonical docs

| Doc | Use for |
|-----|---------|
| `README.md` | Overview, run, status |
| `MVP_SPEC.md` | Scope in / out |
| `DEVELOPMENT_PLAN.md` | Phases |
| `ARCHITECTURE.md` | Code structure + data flow |
| `PROJECT_CONTEXT.md` | Short current snapshot |
| `docs/CURRENT_STATUS.md` | Phase 3.5 status |
| `docs/06_Design_System.md` | UI direction |

## Current focus

Phase **3.5** — Full UI redesign (playdate-first Korean mom community). Respect architecture freeze; UI/UX and justified shared components are in scope.
