# PROJECT_CONTEXT

Short snapshot for agents. Prefer this + `CLAUDE.md` before inventing scope.

## Version

MOMO MVP 0.1 — Phase 3 in progress (repository layer added)

## What exists in code

- Flutter + Material 3 + design system (`core/theme`, `core/widgets`)
- Bottom nav: Home / Create / Profile (`MainShell`)
- Riverpod providers for playdates, posts, feed, user, tabs
- **Repository layer:** providers → repository → **data source** → mock seed
- Seed data in `lib/data/mock_feed.dart` (consumed by mock **data sources** only for feed)
- Create / join / leave / cancel update local repository state → Home feed
- Profile still reads `mockProfile` directly (no profile repository yet)

## Hard constraints

- Mock / local only — no backend / Supabase yet
- No Business / marketplace
- No comments, photos, search, chat, notifications, payments

## Docs map

- Spec → `MVP_SPEC.md`
- Plan → `DEVELOPMENT_PLAN.md`
- Architecture → `ARCHITECTURE.md`
- Agent rules → `CLAUDE.md`
