# PROJECT_CONTEXT

Short snapshot for agents. Prefer this + `CLAUDE.md` before inventing scope.

## Version

MOMO MVP 0.1 — **Phase 1 complete**

## What exists in code

- Flutter + Material 3 theme
- Bottom nav: Home / Create / Profile (`MainShell`)
- Home feed from `lib/data/mock_feed.dart`
- Playdate + Post models, cards, detail screens
- Create Playdate / Create Post forms (local validation; no feed write)
- Profile mock placeholder
- Riverpod: `ProviderScope` only

## Current focus (Phase 2)

- Connect Create → Home feed via local Riverpod state
- Join playdate (local)
- UX polish

## Hard constraints

- Mock / local only — no backend
- No Business / marketplace
- No Community tab beyond the three nav items
- No comments, photos, search, chat, notifications, payments

## Docs map

- Spec → `MVP_SPEC.md`
- Plan → `DEVELOPMENT_PLAN.md`
- Architecture → `ARCHITECTURE.md`
- Agent rules → `CLAUDE.md`
