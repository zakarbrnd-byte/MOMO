# MOMO

Playdate matching app for Korean moms. MVP 0.1.

## Stack

- Flutter (Material 3)
- Mock data only (no backend, no auth)
- `flutter_riverpod` declared (`ProviderScope` in `main.dart`) — **no providers in use yet**
- Current state: local `setState` (tabs) + static `MockFeed`

## Status

| Area | Status |
|------|--------|
| Home Feed | Done (mixed Playdate/Post cards) |
| Create / Profile tabs | Placeholders |
| Detail / Create forms | Not built yet |

See `docs/03_MVP_Features.md` and `docs/04_User_Flow.md`.

## Run

```bash
flutter pub get
flutter run
```

Platforms: `android/` · `ios/` · `web/`

## Structure

```
lib/
  main.dart              # Entry + ProviderScope
  app.dart               # MaterialApp
  core/theme/            # Design system tokens
  navigation/            # Home · Create · Profile shell
  features/home/         # Home Feed (Done)
  features/create/       # Placeholder → Create Selection/forms (Next)
  features/profile/      # Placeholder → Profile (Next)
  data/models/           # Playdate, Post, FeedItem, MomUser
  data/mock/             # Mock feed data
  shared/widgets/cards/  # BaseCard, PlaydateCard, PostCard
```

### Feature folder convention (upcoming — no moves yet)

| Feature | Own screens / files under |
|---------|---------------------------|
| Home feed | `features/home/` |
| Create selection + forms | `features/create/` |
| Playdate detail (and playdate-specific UI) | `features/playdate/` *(add when Detail lands)* |
| Post detail (and post-specific UI) | `features/post/` *(add when Detail lands)* |
| Profile | `features/profile/` |
| Shared card widgets | `shared/widgets/cards/` |
| Models / mock | `data/models/`, `data/mock/` |

Do not relocate files until the matching screen is implemented.

## Design notes

Feed card chrome: `BaseCard` + `AppCardStyle` (see `docs/06_Design_System.md`).

See `CLAUDE.md` and `docs/` for product scope.
