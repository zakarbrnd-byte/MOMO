# Backend Migration Checklist

MOMO MVP readiness for replacing mock data sources with Supabase (or any remote API).

**Do not connect Supabase until this checklist is signed off.**

---

## 1. Architecture readiness

- [x] UI talks only to Riverpod feature providers (no mock / repository / data-source imports in `features/`)
- [x] Feature providers depend on repository **interfaces** via `*RepositoryProvider`
- [x] Repositories depend on data-source **interfaces** via `*DataSourceProvider`
- [x] Mock collections live only in mock data sources / seed files under `lib/data/`
- [x] Request lifecycle documented (`Idle → Loading → Success | Error → Retry`)
- [x] `Result` type for repository mutation outcomes
- [x] DTOs with `fromJson` / `toJson` / `toDomain` / `fromDomain` for Playdate, Post, User, Participant, Profile, Child
- [x] Riverpod DI overrides prepared in `test/support/test_overrides.dart`

**Target stack**

```
UI → Provider → Repository interface → Repository impl
  → Data Source interface → Mock*DataSource (today)
                         → Supabase*DataSource (next)
```

---

## 2. Database readiness

| Entity | Domain fields ready | Notes |
|--------|---------------------|-------|
| Playdate | id, creatorId, title, description, location, date, time, childAge, hostName, maxParticipants, participantIds, status, createdAt, updatedAt | `date`/`time` still display **strings** — decide DB columns (`timestamptz` vs text) before schema freeze |
| Post | id, title, content, authorName, creatorId, status, createdAt, updatedAt | Reserve columns for images / likes / comments later |
| User | id, displayName, profileImageUrl, location, children, createdAt, updatedAt | Map to auth `uid` |
| Profile | displayName, neighborhood, childInfo, bio | May merge into `profiles` table with User |
| Participant | userId, playdateId, joinedAt, status | Prefer join table over array long-term |

- [ ] Finalize Postgres schema / Supabase tables
- [ ] Decide participant storage: `participantIds text[]` vs `playdate_participants` table
- [ ] RLS policies drafted (creator-only delete, join rules)
- [ ] Seed / migration scripts

---

## 3. Authentication readiness

- [ ] Choose Supabase Auth (email / magic link / OAuth)
- [ ] Replace `MockUserDataSource` with session-backed `SupabaseUserDataSource`
- [ ] Map `currentUserProvider` → authenticated user (same `User` domain type)
- [ ] Gate create / join behind signed-in user
- [ ] Secure storage of session (flutter_secure_storage / supabase_flutter)

Current: `userRepositoryProvider` → `MockUserDataSource` (`user_001` / Demo User).

---

## 4. Repository replacement steps

1. Implement `SupabasePlaydateDataSource` / `SupabasePostDataSource` / `SupabaseUserDataSource` / `SupabaseProfileDataSource` against `*_data_source.dart` contracts.
2. Map JSON rows with existing DTOs (`PlaydateDto.fromJson`, etc.).
3. Override providers in app bootstrap (no UI edits):

```dart
ProviderScope(
  overrides: [
    playdateDataSourceProvider.overrideWithValue(SupabasePlaydateDataSource(client)),
    postDataSourceProvider.overrideWithValue(SupabasePostDataSource(client)),
    userDataSourceProvider.overrideWithValue(SupabaseUserDataSource(client)),
    profileDataSourceProvider.overrideWithValue(SupabaseProfileDataSource(client)),
  ],
  child: const MomoApp(),
)
```

4. Optionally replace `*RepositoryImpl` with Supabase-specific repositories **only if** rules must live server-side; prefer keeping impls and swapping data sources first.
5. Remove mock delay reliance; keep `MutationNotifier` + `AsyncOpState` for Loading / Error / Retry.
6. Replace provider `_readSync` helpers with `async`/`await` once Futures are truly async.

---

## 5. Supabase integration steps (ordered)

1. Create Supabase project + enable Auth  
2. Create tables matching domain / DTO field names (camelCase in JSON via views or map in DTO)  
3. Add `supabase_flutter` dependency  
4. Implement data sources (read/write/update/delete/join/leave)  
5. Wire DI overrides behind a flavor / `AppConfig.useSupabase`  
6. Run full widget + unit tests with fakes; then device smoke tests  
7. Turn off mock data sources in production builds  
8. Monitor errors via `AsyncOpError` / crash reporting  

---

## 6. Known gaps before Phase 4

| Gap | Severity | Action |
|-----|----------|--------|
| Playdate `date`/`time` as strings | Medium | Schema decision |
| Join/leave not on full mutation Loading UI | Low | Wire `playdateParticipationMutationProvider` |
| Profile activity counts hardcoded (`3` / `2`) | Low | Derive from repositories |
| No network error taxonomy | Medium | Map Supabase errors → `Result.failure` messages |
| No offline cache | Low | Optional repository cache layer later |

---

## 7. Sign-off

| Check | Owner | Date |
|-------|-------|------|
| Architecture audit | | |
| Schema draft | | |
| Auth plan | | |
| First Supabase data source spike | | |
