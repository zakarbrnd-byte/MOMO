# Architecture

## Overview

MOMO is a Flutter client with feature-first folders under `lib/`. MVP data is local mock only.

```
UI (features/*)
    ↓
Riverpod providers  (domain models only — never DTOs or data sources)
    ↓
Repository          (business rules, caching later, chooses data source)
    ↓
Data Source         (raw read/write)
    ↓
Mock store / future Supabase
```

## Repository vs Data Source

| | Repository | Data Source |
|--|------------|-------------|
| Knows about | Domain rules, DTOs, which source to use | Storage / API only |
| Examples | Owner cannot join; capacity checks; map DTO→domain | Insert row, fetch list, update participants |
| Swapped when | Rarely (API to app stays stable) | Mock → Supabase (or cache + remote) |
| Seen by providers? | Yes (via interface) | **No** |

**Future Supabase:** implement `SupabasePlaydateDataSource` / `SupabasePostDataSource`, override `playdateDataSourceProvider` / `postDataSourceProvider`. Repositories, providers, and UI stay unchanged. Optional later: repository talks to local cache + remote source.

## DTO vs Domain Model

| | Domain (`lib/models/`) | DTO (`lib/dto/`) |
|--|------------------------|------------------|
| Purpose | App logic & UI | Wire format for API / DB JSON |
| Used by | UI, providers | Data layer (repos / sources) |
| Serialization | None | `fromJson` / `toJson` |

**Providers must never use DTOs or data sources.**

## Flutter layout

| Layer | Responsibility |
|-------|----------------|
| `providers/` | Riverpod notifiers → repositories only |
| `repositories/` | Interfaces + impls (rules + DTO mapping) |
| `data/datasources/` | Raw persistence contracts + mock impls |
| `data/` | Seed constants (`mock_feed`, `mock_user`) |
| `dto/` | JSON DTOs + domain mapping |
| `models/` | Domain entities |

## Folder structure (data-related)

```
lib/
├── models/
├── dto/
├── data/
│   ├── mock_feed.dart
│   ├── mock_user.dart
│   └── datasources/
│       ├── playdate_data_source.dart
│       ├── post_data_source.dart
│       └── mock/
│           ├── mock_playdate_data_source.dart
│           └── mock_post_data_source.dart
├── repositories/
│   ├── playdate_repository.dart
│   ├── playdate_repository_impl.dart
│   ├── post_repository.dart
│   ├── post_repository_impl.dart
│   └── repository_providers.dart
└── providers/
```

## Data flow (Phase 3.4.4)

```
HomeScreen → feedProvider → playdateProvider / postProvider
                                    ↓
                         PlaydateRepositoryImpl / PostRepositoryImpl
                                    ↓
                         MockPlaydateDataSource / MockPostDataSource
                                    ↓
                         mock_feed.dart seed lists
```

Create / join / leave / cancel: repository applies rules → data source mutates store → providers refresh from `getPlaydates()` / `getPosts()`.

## Models

- **User:** id, displayName, profileImageUrl, location, children, createdAt, updatedAt (`name` alias → displayName)
- **Playdate:** id, title, description, location, date, time, childAge, hostName, maxParticipants, participantIds, creatorId, status, createdAt, updatedAt (`isCancelled` derived from status)
- **Post:** id, title, content, authorName, creatorId, status, createdAt, updatedAt
- **Participant:** userId, playdateId, joinedAt, status (future join table; MVP uses `participantIds`)
- **Child:** id, displayName, ageLabel (nested under User)
- **FeedItem:** sealed — `PlaydateFeedItem` | `PostFeedItem`

Dates/times on playdates remain display strings in MVP. Entity timestamps use `DateTime?`.

## UI

- Material 3 via `AppTheme.light`
- Shared feedback widgets under `core/widgets/`

## Constraints

- No backend, auth, or remote persistence yet
- Do not introduce marketplace, chat, payments, or complex matching
- Profile still reads `mockProfile` directly (no profile repository yet)
