# MOMO

Playdate matching app for Korean moms. MVP 0.1.

## Stack

- Flutter
- Riverpod
- Mock data only (no backend, no auth)

## Run

```bash
flutter pub get
flutter run
```

Platforms: `android/` · `ios/` · `web/`

## Structure

```
lib/
  main.dart              # Entry
  app.dart               # MaterialApp
  core/theme/            # Design system
  navigation/            # Home · Create · Profile shell
  features/home/         # Home Feed (mock)
  features/create/       # Placeholder
  features/profile/      # Placeholder
  data/models/           # Playdate, Post, FeedItem, MomUser
  data/mock/             # Mock feed data
  shared/widgets/cards/  # BaseCard, PlaydateCard, PostCard
```

See `CLAUDE.md` and `docs/` for product scope.
