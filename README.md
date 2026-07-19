# MOMO

Community app for Korean mothers in the US.

**MVP goal:** Help moms discover and create local playdates, and share parenting-related posts.

Version: **MVP 0.1** · Status: **Phase 1 complete** (UI + mock data)

## Current features

| Area | Status |
|------|--------|
| Flutter app shell + Material theme | Done |
| Bottom nav: Home · Create · Profile | Done |
| Home feed (Playdate + Post cards) | Done |
| Detail screens (Playdate, Post) | Done |
| Create selection + forms | Done |
| Profile (placeholder mock) | Done |
| Local mock data | Done |
| Backend / auth | Not started |
| Create → feed persistence | Not started |

## Tech stack

- **Framework:** Flutter
- **State management:** Riverpod (`ProviderScope` wired; feature providers not yet used)
- **UI:** Material Design 3
- **Data:** Local mock data only (`lib/data/mock_feed.dart`)

## Project structure

```
lib/
  main.dart                 # Entry + ProviderScope
  app.dart                  # MaterialApp
  core/theme/               # Colors + theme
  navigation/               # MainShell (bottom nav)
  features/
    home/                   # Feed + card widgets
    create/                 # Selection + playdate/post forms
    detail/                 # Playdate + post detail
    profile/                # Profile screen
  models/                   # Playdate, Post
  data/                     # Mock feed + profile
```

## Run

```bash
flutter pub get
flutter run
```

**Windows note:** The project path must not contain `#` (Flutter rejects it). If the repo lives under a folder like `#1 ZAKAR`, run from a junction/symlink without `#`, e.g. `C:\Users\Tim\Projects\ZAKAR-MOMO`, or ensure `flutter` is on PATH (`C:\Users\Tim\flutter\bin`).

Devices currently used in development: Chrome (web). Windows desktop / Android toolchains are optional and may not be configured.

## Documentation

| File | Purpose |
|------|---------|
| [MVP_SPEC.md](MVP_SPEC.md) | Scope, users, included / excluded |
| [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) | Phases: completed / next / future |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Folders, navigation, data flow |
| [CLAUDE.md](CLAUDE.md) | Agent / contributor rules |
| [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) | Short current-state snapshot |
| [docs/](docs/) | Supporting product notes (synced to MVP) |

## Development status

- **Completed:** Phase 1 — foundation, navigation, feed, cards, create/detail screens, mock data
- **Next:** Phase 2 — local state (Riverpod), create → feed, join, UX polish
- **Future:** Phase 3 — auth, backend, richer profiles, realtime community
