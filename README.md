# MOMO

Community app for Korean mothers in the US.

**Product vision:** Join trusted communities of Korean mothers in your area, participate in discussions, and organize activities together.

Version: **MVP 0.1** · Status: **Launch Sprint 1.1 — Post comments (local mock)**

## What MOMO is

MOMO helps Korean mothers discover and join **Groups** (persistent communities) based on shared interests, child age, and location.

Offline meetups are **Event Announcements** created *inside* Groups — not standalone stranger meetups.

```
MOMO
├── Community Feed
├── Groups
│      ├── Members
│      ├── Posts
│      └── Event Announcements
└── User Profiles
```

## Why this direction

User interviews with real mothers showed:

- Moms often feel uncomfortable meeting strangers 1-on-1
- They prefer joining an **existing community** first
- Trust is built inside Groups
- Meetups happen naturally after belonging

The earlier Playdate-first MVP validated technical foundations. The product is now **Group-first**.

## Current engineering status

The Flutter client still ships the Playdate-first local MVP (feed cards, create flows, mock data, Riverpod + repository architecture). That code is a **technical foundation**, not the long-term product shape.

| Area | Status |
|------|--------|
| Flutter app shell + Material 3 + design system | Done (foundation) |
| Bottom nav: Home · Create · Groups · Profile | Done (Phase 3.7.1) |
| Local mock feed / create / detail / join | Done (legacy Playdate-shaped UI) |
| Repository + data source + DI layer | Done (reuse for Groups) |
| Groups / Event Announcements (local mock) | **Done** (Phase 3.7) |
| Home Group Cards + content-first Group Detail + Group Info + RSVP | **Done** (Phase 3.7.2) |
| Home Group discovery (search, filters, recommendations) | **Done** (Phase 3.8) |
| Post comments + one-level replies (local mock) | **Done** (Launch Sprint 1.1) |
| Backend / auth / Supabase | Not started (Phase 4.0+) |

## Tech stack

- **Framework:** Flutter
- **State:** Riverpod (feature providers + DI)
- **UI:** Material 3 + shared `core/widgets`
- **Data:** Mock data sources only (swap-ready for Supabase)

## Run

```bash
flutter pub get
flutter run
```

**Windows note:** The project path must not contain `#`. Prefer a junction without `#`, e.g. `C:\Users\Tim\Projects\ZAKAR-MOMO`.

## Documentation

| File | Purpose |
|------|---------|
| [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) | **Single source of truth** for product context |
| [MVP_SPEC.md](MVP_SPEC.md) | Target MVP scope (Group-first) |
| [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) | Phases 3.6 → 4.5 roadmap |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Engineering layers + intended domain |
| [docs/ARCHITECTURE_FREEZE.md](docs/ARCHITECTURE_FREEZE.md) | Historical Playdate-era freeze (**superseded**) |
| [BACKEND_MIGRATION_CHECKLIST.md](BACKEND_MIGRATION_CHECKLIST.md) | Pre-Supabase engineering checklist |
| [CLAUDE.md](CLAUDE.md) | Agent rules |

## Development status

- **Completed:** Phases 1–3.8 + Launch Sprint 1.1 — foundation, Groups / Events / RSVP, Home discovery, Post comments (one-level replies, local)
- **Next:** Phase 3.9 — Profile onboarding
- **Later:** Auth/Supabase, likes, push notifications, safety, pilot
- **Note:** Comments are local/mock only (no multi-user persistence); likes and push are not started
