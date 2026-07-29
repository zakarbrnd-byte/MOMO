# Architecture Freeze — Historical Baseline (Superseded)

> **SUPERSEDED (Phase 3.6)**  
> This freeze documented the **Playdate-first** MVP engineering baseline (Phase 3.4.8).  
> It has been **retired as the product/architecture baseline** after the Group-first product pivot.  
>
> - **Product truth now:** [`../PROJECT_CONTEXT.md`](../PROJECT_CONTEXT.md) · [`../MVP_SPEC.md`](../MVP_SPEC.md)  
> - **Live engineering layers:** [`../ARCHITECTURE.md`](../ARCHITECTURE.md)  
> - **Roadmap:** [`../DEVELOPMENT_PLAN.md`](../DEVELOPMENT_PLAN.md)  
>
> Keep this file for historical context. Do **not** treat Playdate-first freeze rules as blocking Group domain work in Phase 3.7+.  
> Layering pattern (UI → Provider → Repository → Data Source) remains the preferred engineering approach.

---

## 1. Freeze Date (historical)

**2026-07-22**

Phase **3.4.8** — Architecture freeze before Phase **3.5** UI/UX validation (Playdate-era).

---

## 2. Current Architecture Diagram (still accurate as layering)

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

**UI and feature providers should not need major rewrites** for storage swaps. Domain expansion for Groups is expected in Phase 3.7+.

---

## 5. Architecture Verification (3.4.8) — historical checklist

| Check | Result |
|-------|--------|
| UI does not import mock data | **Pass** (as of 3.4.8) |
| Providers do not bypass repositories | **Pass** |
| Repositories have no UI logic | **Pass** |
| Data sources separated from repositories | **Pass** |
| DI centralized | **Pass** |

### Documented non-blocking notes (Playdate-era)

- `playdateParticipationMutationProvider` exists but join/leave UI may update list state directly.
- Provider sync helpers assume mock `SynchronousFuture` until real network (Phase 4.0).
- Profile activity counts may be UI literals.

---

## 6. Known Limitations (historical / still partly true)

- Authentication uses a mock user
- No real database — in-memory mock only
- Legacy Playdate date/time fields are display strings
- Participant model vs `participantIds` array decision pending for backend
- No Supabase client / RLS yet

**Product note:** Event Announcement + Group models supersede standalone Playdate as the primary meetup concept going forward.

---

## 7. Rules after Phase 3.6

The Phase 3.5 “UI-only / freeze domain” rule set is **no longer the product baseline**.

For new work:

- Follow `DEVELOPMENT_PLAN.md` for the active phase
- Prefer Group-first domain changes when the phase requires them
- Keep DI layering intact unless a phase explicitly redesigns it
- Do not resurrect Playdate-first product language in new docs or features

---

## 8. Phase Status (updated)

| Phase | Status |
|-------|--------|
| 3.4.x Backend architecture preparation | Complete (historical freeze) |
| 3.5 UI/UX validation | Complete (foundation UI) |
| 3.6 Product pivot & docs | **Current** |
| 3.7 Group + Event local models | **Next** |
| 4.0+ Auth / Supabase / engagement | Future |
