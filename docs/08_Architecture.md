# Architecture (summary)

**Frozen baseline (Phase 3.4.8):** [`ARCHITECTURE_FREEZE.md`](ARCHITECTURE_FREEZE.md)  
**Full live detail:** [`../ARCHITECTURE.md`](../ARCHITECTURE.md)  
**Backend prep:** [`../BACKEND_MIGRATION_CHECKLIST.md`](../BACKEND_MIGRATION_CHECKLIST.md)

## Stack

```
UI → Riverpod Providers → Repository interfaces → Repository impls
  → Data Source interfaces → Mock Data Sources
```

- Flutter + Material 3 + shared widgets
- Feature folders under `lib/features/` (UI only)
- Riverpod for state **and** dependency injection
- Seed data only under `lib/data/` (consumed by mock data sources)
- DTOs under `lib/dto/` for future JSON ⇄ domain

## Navigation

`MainShell` tabs (Home · Create · Profile) + nested `Navigator` for detail/create.

## Status

| Stage | State |
|-------|--------|
| Phase 3.4 backend architecture prep | Complete / **frozen** |
| Phase 3.5 UI/UX validation | **Next** |
| Phase 4 Supabase / auth | Future |

During Phase 3.5, prefer UI/UX changes only. Treat domain, repository, and data-source contracts as frozen unless reviewed.
