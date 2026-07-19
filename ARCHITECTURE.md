# Architecture

## Overview

MOMO is a Flutter client with feature-first folders under `lib/`. MVP data is local mock only. Riverpod is installed and the app root is wrapped in `ProviderScope`; feature-level providers are Phase 2 work.

```
UI (features/*) → models → mock data (data/)
         ↑
   navigation/MainShell
         ↑
      app.dart / main.dart
```

## Flutter layout

| Layer | Responsibility |
|-------|----------------|
| `main.dart` | `WidgetsFlutterBinding`, `ProviderScope`, `runApp` |
| `app.dart` | `MaterialApp`, theme, `home: MainShell` |
| `core/theme/` | `AppColors`, `AppTheme` (Material 3) |
| `navigation/` | Bottom nav + `IndexedStack` of root tabs |
| `features/` | Screens and feature widgets |
| `models/` | Plain Dart data classes |
| `data/` | Mock feed items + mock profile |

## Folder structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
├── navigation/
│   └── main_shell.dart          # Home / Create / Profile tabs
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── playdate_card.dart
│   │       └── post_card.dart
│   ├── create/
│   │   ├── create_screen.dart
│   │   ├── create_playdate_screen.dart
│   │   └── create_post_screen.dart
│   ├── detail/
│   │   ├── playdate_detail_screen.dart
│   │   └── post_detail_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── models/
│   ├── playdate.dart
│   └── post.dart
└── data/
    └── mock_feed.dart           # FeedItem, mock lists, mockProfile
```

## Navigation

**Root tabs** (`MainShell`):

1. Home → `HomeScreen`
2. Create → `CreateScreen`
3. Profile → `ProfileScreen`

Tabs use `IndexedStack` so tab state is preserved while switching.

**Pushed routes** (`Navigator.push` / `MaterialPageRoute`):

- Home card → `PlaydateDetailScreen` or `PostDetailScreen`
- Create action → `CreatePlaydateScreen` or `CreatePostScreen`

No named routes / go_router in MVP.

## State management

| Status | Detail |
|--------|--------|
| Installed | `flutter_riverpod` |
| Wired | `ProviderScope` in `main.dart` |
| Used today | Almost none — screens read const mock data / local `StatefulWidget` form controllers |
| Next (Phase 2) | Providers for feed list, create actions, join flags |

Prefer Riverpod for shared app state. Keep form field controllers in the create screen `State` unless a clear need arises.

## Data flow (current MVP)

1. `mock_feed.dart` defines const `Playdate` / `Post` values and `mockFeedItems`.
2. `HomeScreen` iterates `mockFeedItems` and builds `PlaydateCard` / `PostCard`.
3. Card tap passes the model into a detail screen via constructor.
4. Create forms validate locally; on submit they show a SnackBar and `pop`. They do **not** mutate the feed yet.
5. `ProfileScreen` reads `mockProfile`.

```
mockFeedItems ──► HomeScreen ──► Card ──push──► DetailScreen(model)
CreateForm ──validate──► SnackBar + pop   (no feed write)
mockProfile ──► ProfileScreen
```

## Models

- **Playdate:** id, title, date, time, location, childAge, description, hostName
- **Post:** id, title, content, authorName
- **FeedItem:** sealed — `PlaydateFeedItem` | `PostFeedItem`

Dates/times are display strings in MVP (not `DateTime` pickers yet).

## UI

- Material 3 via `AppTheme.light`
- Warm palette in `AppColors`
- Cards are the primary interaction surface on Home and Create

## Constraints

- No backend, auth, or persistence in Phase 1
- Do not introduce marketplace, chat, payments, or complex matching
- Keep architecture simple; add layers only when Phase 2 state requires them
