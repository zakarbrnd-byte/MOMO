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

## Structure

```
lib/
  main.dart              # Entry
  app.dart               # MaterialApp
  core/theme/            # Design system (colors, type, spacing, card, button)
  navigation/            # Home · Create · Profile shell
  features/              # Screen placeholders
  data/models/           # Playdate, Post, MomUser
  shared/widgets/cards/  # BaseCard, PlaydateCard, PostCard
```

See `CLAUDE.md` and `docs/` for product scope.
