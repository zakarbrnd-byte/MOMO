# Architecture (summary)

**Product baseline:** [`../PROJECT_CONTEXT.md`](../PROJECT_CONTEXT.md)  
**Full engineering detail:** [`../ARCHITECTURE.md`](../ARCHITECTURE.md)  
**Historical freeze (superseded):** [`ARCHITECTURE_FREEZE.md`](ARCHITECTURE_FREEZE.md)  
**Backend prep:** [`../BACKEND_MIGRATION_CHECKLIST.md`](../BACKEND_MIGRATION_CHECKLIST.md)

## Stack

```
UI → Riverpod Providers → Repository interfaces → Repository impls
  → Data Source interfaces → Mock Data Sources
```

- Flutter + Material 3 + shared widgets
- Feature folders under `lib/features/` (UI only)
- Riverpod for state **and** dependency injection
- Seed data under `lib/data/` (consumed by mock data sources)
- DTOs under `lib/dto/` for future JSON ⇄ domain

## Intended domain

```
User → Group → Post → Comment → Event Announcement → RSVP
```

Current code still uses Playdate + Post models as foundation until Phase 3.7.

## Navigation (today)

`MainShell` tabs (Home · Create · Profile) + nested `Navigator` for detail/create.

## Status

| Stage | State |
|-------|--------|
| Phase 3.6 Product pivot & docs | **Current** |
| Phase 3.7 Group + Event models | **Next** |
| Phase 4.0 Supabase / auth | Future |
