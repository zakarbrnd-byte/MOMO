# Architecture Freeze — Baseline Checkpoint

## 1. Freeze Date

**2026-07-22**

Phase **3.4.8** — Architecture freeze before Phase **3.5** UI/UX validation.

This document is a **stable engineering baseline**. Do not treat it as permission to redesign layers during Phase 3.5.

---

## 2. Current Architecture Diagram

```
UI (lib/features/*, navigation)
        ↓
Riverpod Providers (lib/providers/*, mutation notifiers)
        ↓
Repository Interfaces (lib/repositories/*_repository.dart)
        ↓
Repository Implementations (*_repository_impl.dart)
        ↓
Data Source Interfaces (lib/data/datasources/*_data_source.dart)
        ↓
Mock Data Sources (lib/data/datasources/mock/*)
        ↓
Seed constants (lib/data/mock_feed.dart, mock_user.dart)
```

**Dependency injection (composition root):**

```
ProviderScope (main.dart)
  → *DataSourceProvider  → Mock*DataSource
  → *RepositoryProvider  → *RepositoryImpl(ref.watch(*DataSourceProvider))
  → Feature providers    → ref.watch(*RepositoryProvider)
```

Canonical live detail: [`../ARCHITECTURE.md`](../ARCHITECTURE.md)  
Migration checklist: [`../BACKEND_MIGRATION_CHECKLIST.md`](../BACKEND_MIGRATION_CHECKLIST.md)

---

## 3. Layer Responsibilities

### UI

- Screens and widgets under `lib/features/`
- User interaction (taps, forms, navigation)
- Renders state from Riverpod (`ref.watch`)
- Shared look-and-feel via `lib/core/widgets/` and theme

**Must not:** import mock seed files, repositories, data sources, or DTOs.

### Providers

- App / feature state (`AsyncValue`, list notifiers, tabs, current user, profile)
- UI-facing async lifecycle (`MutationNotifier` / `AsyncOpState` for create flows)
- Call **repository interfaces** only (via `*RepositoryProvider`)

**Must not:** construct repositories/data sources manually; import mock seed for feature data.

### Repositories

- Business data operations (`load`, `create`, `update`, `delete`, `join`, `leave`)
- Rules (ownership, capacity) and `Result` mapping
- DTO round-trip boundary where applied
- Backend abstraction for providers

**Must not:** contain UI widgets, `BuildContext`, or snackbars; hold hardcoded mock collections.

### Data Sources

- External / local I/O (read, write, update, delete, join, leave)
- **Replacement point** for Mock → Supabase (same interface, DI override)
- Own in-memory stores / seed loading today

**Must not:** contain UI logic or provider state.

---

## 4. Backend Migration Strategy

### Current

```
Provider → Repository → MockDataSource → seed / memory
```

### Future

```
Provider → Repository → SupabaseDataSource → Supabase / DB
```

(Optional later: `Repository → Cache + SupabaseDataSource`.)

**UI and feature providers should not need major rewrites.** Swap by overriding `*DataSourceProvider` (preferred) or `*RepositoryProvider` in `ProviderScope`. See `BACKEND_MIGRATION_CHECKLIST.md`.

---

## 5. Architecture Verification (3.4.8)

| Check | Result |
|-------|--------|
| UI does not import mock data | **Pass** — no `mock_*` imports under `lib/features/` |
| Providers do not bypass repositories | **Pass** — feature providers `ref.watch(*RepositoryProvider)` |
| Repositories have no UI logic | **Pass** — no `BuildContext` / widgets in `lib/repositories/` |
| Data sources separated from repositories | **Pass** — mock stores only under `datasources/mock/` |
| DI centralized | **Pass** — `data_source_providers.dart` + `repository_providers.dart` |

### Documented non-blocking notes (not layer violations)

- `playdateParticipationMutationProvider` exists but join/leave UI still updates list state directly (same UX; full Loading path deferred).
- Provider `_readSync` assumes mock `SynchronousFuture` — fine until real network (Phase 4).
- Profile activity counts (`3` / `2`) are UI literals, not mock-file imports.

**No automatic refactors performed in 3.4.8.**

---

## 6. Known Limitations Before Backend

These belong to **Phase 4** (or later). Do **not** fix during Phase 3.5 unless product explicitly expands scope.

- Authentication uses a **mock user** (`MockUserDataSource` / seed `user_001`)
- **No real database** — in-memory mock only
- Playdate **date/time** fields are display **strings** — may need schema refinement
- **Participant** domain model exists; live path still uses `participantIds` — backend table vs array decision pending
- **Profile statistics** are not backend-driven (hardcoded activity numbers on Profile)
- No Supabase client, RLS, or production error taxonomy yet

---

## 7. Architecture Rules After Freeze

### Allowed during Phase 3.5 (UI / UX validation)

- UI layout, spacing, colors, typography
- Components, buttons, cards, feedback visuals
- Navigation presentation improvements
- Copy / microcopy / empty-state presentation
- User experience polish that does **not** change data contracts

### Require review before modifying

- Domain models (`lib/models/`)
- Repository interfaces and method signatures
- Data layer (`lib/data/datasources/`, seed files)
- Provider architecture / DI wiring (`*RepositoryProvider`, `*DataSourceProvider`)
- DTO contracts (`lib/dto/`)
- Request lifecycle / `Result` / mutation contracts

If a Phase 3.5 task seems to need a reviewed change, stop and confirm before editing those layers.

---

## 8. Phase Status

| Phase | Status |
|-------|--------|
| 3.4.x Backend architecture preparation | **Complete / frozen** |
| 3.5 UI/UX validation | **Next** |
| 4 Backend / auth / Supabase | **Future** |

**Freeze readiness:** Ready for Phase 3.5 UI validation against this baseline.
