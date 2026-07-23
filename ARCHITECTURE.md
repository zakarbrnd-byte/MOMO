# Architecture

## Overview

MOMO is a Flutter client with feature-first folders under `lib/`. MVP data is local mock only.

```
UI (features/*)
    ↓
Riverpod feature providers  (domain + AsyncOpState / AsyncValue only)
    ↓
Repository providers        (interfaces — DI)
    ↓
Repository implementations
    ↓
Data source providers       (interfaces — DI)
    ↓
Mock / future Supabase data sources
```

---

## Dependency injection (Phase 3.4.6)

**Dependency injection (DI)** means callers receive collaborators from the outside instead of constructing them. In MOMO, Riverpod is the DI container:

| Provider | Exposes | Default binding |
|----------|---------|-----------------|
| `playdateDataSourceProvider` | `PlaydateDataSource` | `MockPlaydateDataSource` |
| `postDataSourceProvider` | `PostDataSource` | `MockPostDataSource` |
| `profileDataSourceProvider` | `ProfileDataSource` | `MockProfileDataSource` |
| `userDataSourceProvider` | `UserDataSource` | `MockUserDataSource` |
| `playdateRepositoryProvider` | `PlaydateRepository` | `PlaydateRepositoryImpl` |
| `postRepositoryProvider` | `PostRepository` | `PostRepositoryImpl` |
| `profileRepositoryProvider` | `ProfileRepository` | `ProfileRepositoryImpl` |
| `userRepositoryProvider` | `UserRepository` | `UserRepositoryImpl` |

**Why Riverpod for DI**

- Same tool already used for app state (`ProviderScope` in `main.dart`)
- Feature notifiers `ref.watch` repository **interfaces** only
- Tests / future backends override bindings without changing UI code

**Swap mock → Supabase (no UI changes)**

```dart
// Option A — swap data source only (keep PlaydateRepositoryImpl)
playdateDataSourceProvider.overrideWithValue(SupabasePlaydateDataSource(...))

// Option B — swap entire repository
playdateRepositoryProvider.overrideWithValue(SupabasePlaydateRepository(...))
```

**Testing**

Helpers in `test/support/test_overrides.dart`:

- `overridePlaydateRepository` / `overridePostRepository`
- `overridePlaydateDataSource` / `overridePostDataSource`
- `testBackendOverrides` (instant simulated backend)

```
ProviderScope(overrides: [overridePlaydateRepository(fake)])
  → feature providers
  → fake repository
```

Composition root files:

- `lib/data/datasources/data_source_providers.dart`
- `lib/repositories/repository_providers.dart`

Feature providers (`playdate_provider`, `post_provider`) must **not** import mock/impl classes.

---

## Backend request flow (Phase 3.4.5)

Every future backend operation (create, read, update, delete, join, leave, login, …) follows the same path:

```
User
 ↓
Tap button
 ↓
Provider
 ↓
Repository
 ↓
Data Source
 ↓
API (future)
 ↓
Database (future)
 ↓
API response
 ↓
Data Source
 ↓
Repository   (DTO → Domain, Result)
 ↓
Provider     (AsyncOpState / AsyncValue)
 ↓
UI refresh   (MomoLoading / MomoError / list / banner)
```

### Request lifecycle (mutations)

```
Idle
 ↓
Loading          ← MutationNotifier / AsyncOpLoading
 ↓
Success          ← AsyncOpSuccess → navigate / snackbar / refresh list
 ↓
Error            ← AsyncOpError → MomoError + Retry
 ↓
Retry            ← calls the same Provider → Repository path again
```

| State | Who owns it | UI |
|-------|-------------|-----|
| Idle | `MutationNotifier` | Form / action controls enabled |
| Loading | `MutationNotifier` | `MomoLoading` |
| Success | `MutationNotifier` + list providers | Navigate / `MomoSuccessBanner` / refreshed feed |
| Error | `MutationNotifier` | `MomoError` + retry |
| List load | `AsyncNotifier` (`AsyncValue`) | `MomoLoading` / `MomoError` / cards |

### Current flows (where each layer starts / ends)

| Operation | UI | Provider | Repository | Data source |
|-----------|----|----------|------------|-------------|
| **Load feed** | `HomeScreen` | `feedProvider` ← `playdateProvider` / `postProvider` | `load()` | `getPlaydates` / `getPosts` |
| **Create playdate** | Create screen + `createPlaydateMutationProvider` | `PlaydateNotifier.createPlaydate` | `create()` → `Result` | `createPlaydate` |
| **Create post** | Create screen + `createPostMutationProvider` | `PostNotifier.createPost` | `create()` → `Result` | `createPost` |
| **Join / Leave** | `PlaydateJoinActionBar` | `joinPlaydate` / `leavePlaydate` | `join()` / `leave()` → `Result` | `joinPlaydate` / `leavePlaydate` |
| **Cancel** | Join action bar | `cancelPlaydate` | `delete()` → `Result` | `deletePlaydate` |

**No UI bypasses repositories** for playdate, post, profile, or current user. Join/leave update list state immediately today; wire `playdateParticipationMutationProvider` later for full Loading/Error UI.

### Error propagation

```
API / rule failure
 → Data Source (raw false / throw)
 → Repository maps to Result.failure(message)
 → Provider maps Result → bool / throw for MutationNotifier
 → MutationNotifier → AsyncOpError
 → UI MomoError (retry)
```

Repositories **never** show snackbars or dialogs.

### Response mapping (serialization)

```
Database row (future)
 → JSON
 → DTO (`lib/dto/*_dto.dart` fromJson)
 → Domain (`toDomain()`)
 → Provider
 → UI
```

Today mock sources already hold domain objects; repositories still round-trip through DTOs on `load()` to keep the boundary warm.

### Repository method conventions

| Method | Role | Return |
|--------|------|--------|
| `load()` | Read collection | `Future<List<T>>` |
| `create(...)` | Insert | `Future<Result<bool>>` |
| `update(entity)` | Upsert | `Future<Result<bool>>` |
| `delete(...)` | Remove | `Future<Result<bool>>` |
| `join` / `leave` | Participation | `Future<Result<bool>>` |

Prefer [Result](lib/core/result/result.dart) over throwing for expected business failures. Use [MutationNotifier.runResult](lib/core/async/mutation_notifier.dart) when driving Idle→Loading→Success|Error from a `Result`.

---

## Repository vs Data Source

| | Repository | Data Source |
|--|------------|-------------|
| Knows about | Domain rules, DTOs, Result, which source | Storage / API only |
| Examples | Owner cannot join; capacity; DTO→domain | Insert row, fetch list |
| Swapped when | Rarely | Mock → Supabase |
| Seen by providers? | Yes | **No** |

**Future Supabase:** implement `Supabase*DataSource`, override `*DataSourceProvider`. Repositories, providers, and UI stay unchanged.

## DTO vs Domain Model

| | Domain (`lib/models/`) | DTO (`lib/dto/`) |
|--|------------------------|------------------|
| Purpose | App logic & UI | Wire format for API / DB JSON |
| Used by | UI, providers | Data layer only |

**Providers must never use DTOs or data sources.**

## Flutter layout

| Layer | Responsibility |
|-------|----------------|
| `providers/` | Riverpod notifiers → `ref.watch(*RepositoryProvider)` |
| `repositories/` | Interfaces + impls + `repository_providers.dart` |
| `data/datasources/` | Contracts + mock impls + `data_source_providers.dart` |
| `dto/` | JSON ⇄ domain |
| `core/result/` | `Result` success/failure |
| `core/async/` | `MutationNotifier`, `AsyncOpState`, request-flow notes |

## Folder structure (data-related)

```
lib/
├── models/
├── dto/
├── core/result/result.dart
├── core/async/
│   ├── async_state.dart          (via models/async_state)
│   ├── mutation_notifier.dart
│   └── backend_request_flow.dart
├── data/
│   ├── mock_feed.dart
│   ├── mock_user.dart
│   └── datasources/
├── repositories/
└── providers/
```

## Models

- **User, Playdate, Post, Participant, Child, Profile, FeedItem** — see prior phase notes.
- Playdate `date` / `time` remain display strings in MVP.

## Constraints

- No backend, auth, or remote persistence yet
- See `BACKEND_MIGRATION_CHECKLIST.md` before Phase 4 / Supabase
