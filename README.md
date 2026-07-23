# MOMO

Community app for Korean mothers in the US.

**MVP goal:** Help moms discover and create local playdates, and share parenting-related posts.

Version: **MVP 0.1** · Status: **Phase 3.4 complete (architecture freeze)** → next **Phase 3.5 UI/UX validation**

## Current features

| Area | Status |
|------|--------|
| Flutter app shell + Material 3 + design system | Done |
| Bottom nav: Home · Create · Profile | Done |
| Home feed (Playdate + Post) via Riverpod | Done |
| Detail screens + Join / Leave / Cancel | Done |
| Create Playdate / Post → feed (local) | Done |
| Profile via providers (mock data source) | Done |
| Repository + data source + DI layer | Done |
| Backend / auth / Supabase | Not started |

## Tech stack

- **Framework:** Flutter
- **State:** Riverpod (feature providers + DI)
- **UI:** Material 3 + shared `core/widgets`
- **Data:** Mock data sources only (swap-ready for Supabase)

## Project structure (simplified)

```
lib/
  main.dart                 # ProviderScope
  providers/                # Feature state
  repositories/             # Interfaces + impls + DI
  data/datasources/         # Interfaces + mock impls + DI
  dto/                      # JSON ⇄ domain
  models/                   # Domain
  features/                 # UI only
  core/                     # Theme, widgets, async, result
```

## Run

```bash
flutter pub get
flutter run
```

**Windows note:** The project path must not contain `#`. Prefer a junction without `#`, e.g. `C:\Users\Tim\Projects\ZAKAR-MOMO`.

## Documentation

| File | Purpose |
|------|---------|
| [MVP_SPEC.md](MVP_SPEC.md) | Scope in / out |
| [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) | Phases |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Live architecture detail |
| [docs/ARCHITECTURE_FREEZE.md](docs/ARCHITECTURE_FREEZE.md) | **Frozen baseline (3.4.8)** |
| [BACKEND_MIGRATION_CHECKLIST.md](BACKEND_MIGRATION_CHECKLIST.md) | Pre-Supabase checklist |
| [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) | Short snapshot |
| [CLAUDE.md](CLAUDE.md) | Agent rules |

## Development status

- **Completed:** Phases 1–3.4 — foundation, local state, design system, repositories, DTOs, DI, migration readiness, **architecture freeze**
- **Next:** Phase 3.5 — UI/UX validation (layout/visual/UX only; respect freeze rules)
- **Future:** Phase 4 — auth, Supabase, real persistence
