# CLAUDE.md

Guidance for Cursor agents and contributors working on MOMO.

## Product

**MOMO** — community app for Korean mothers in the US.

**Vision:** Help Korean mothers discover and join **Groups** based on shared interests, child age, and location; discuss with peers; and organize **Event Announcements** inside Groups.

Version: MVP 0.1 · Phase **3.7** complete (local Groups) → **3.8** next

**Read first:** `PROJECT_CONTEXT.md` (single source of truth) · `MVP_SPEC.md` · `DEVELOPMENT_PLAN.md`

## Product structure

```
MOMO
├── Community Feed
├── Groups
│      ├── Members
│      ├── Posts
│      └── Event Announcements
└── User Profiles
```

| Term | Meaning |
|------|---------|
| Group | Persistent community (primary product) |
| Post | Discussion |
| Event Announcement | Meetup *inside* a Group |
| Playdate | Legacy code/UI name — not the long-term primary feature |

## Why Groups first

Interviews: moms often dislike stranger 1-on-1 meetups; they prefer joining a community, building trust, then meeting offline through Group activities.

## Current code vs roadmap

Active UI is **Group-first** (local mock): Home Group Cards, Group Detail, Event RSVP, Create Group/Post. Legacy Playdate code may exist dormant — do not revive it as the primary surface. Next: Phase 3.8 search/filter/recommendations.

## Rules

- Prefer Group-first product language in new work.
- Use mock / local data until Phase 4.0.
- Do not over-engineer.
- Stay inside active-phase scope (`DEVELOPMENT_PLAN.md` + `MVP_SPEC.md`).
- Documentation-only phases must not change Flutter source.

## Out of scope (do not add unless phase says so)

Marketplace, payments, AI recommendations, advanced moderation, real-time chat, advertising. Push notifications wait for Phase 4.4.

## Canonical docs

| Doc | Use for |
|-----|---------|
| `PROJECT_CONTEXT.md` | Product truth |
| `MVP_SPEC.md` | Scope in / out |
| `DEVELOPMENT_PLAN.md` | Roadmap phases |
| `ARCHITECTURE.md` | Engineering layers + intended domain |
| `README.md` | Overview, run, status |

## Next engineering work

Phase **3.8** — Home recommendations, filtering, search (still local/mock).
