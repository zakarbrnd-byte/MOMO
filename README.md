# MOMO

MOMO is a Flutter MVP app helping Korean moms in the US connect through playdates and community posts.

## Project overview

MOMO is a mobile-first MVP focused on **offline connection**. The core product idea is simple:

> Everything is a Card.

There are only two card types in MVP:

1. **Playdate Card** — time, place, host, optional age range  
2. **Post Card** — short mom-to-mom note in the feed  

No backend yet. The Home Feed uses **local mock data** so the UI can be tested on real devices before recruiting early users.

## Current MVP features

| Feature | Status |
|---------|--------|
| Home feed with mixed Playdate + Post cards | Done |
| Shared card design system (`BaseCard`) | Done |
| Bottom navigation: Home · Create · Profile | Done |
| Create tab | Placeholder (create flow not built) |
| Profile tab | Placeholder |
| Playdate / Post detail screens | Not built |
| Create Playdate / Create Post forms | Not built |
| Auth / backend / chat / notifications | Out of scope for this MVP |

Honest status details: [`MOMO_MVP_STATUS.md`](MOMO_MVP_STATUS.md)

## Technology stack

- **Flutter** (Material 3)
- **Dart** SDK `^3.5.0`
- **Mock data only** (no network, no auth)
- `flutter_riverpod` is listed in `pubspec.yaml` and wraps the app with `ProviderScope`, but **no providers are used yet** (tabs use local `setState`; feed reads `MockFeed`)

## Current development status

MVP **UI foundation** is ready for device testing of the feed:

- Warm minimal theme  
- Scrollable Home Feed  
- Reusable Playdate / Post cards  

Create flow and detail screens are **not** ready for user testing of posting or RSVP.

Near-term goal after this public prep:

1. Test UI on real devices  
2. Recruit ~5 moms for early feedback  
3. Iterate based on what they try first  

## Future roadmap

After the feed is validated with moms:

- Create Selection → Create Playdate / Create Post  
- Playdate Detail / Post Detail  
- Real Profile (mock user + their cards)  
- Later (not MVP): auth, backend, search, chat, notifications, business listings  

Product rules live in [`CLAUDE.md`](CLAUDE.md).

## How to run locally

### Requirements

- Flutter stable (3.22+ recommended)
- Chrome **or** an Android device/emulator  
- Xcode / macOS required for iOS builds (not available on all environments)

### Setup

```bash
flutter pub get
flutter doctor
```

### Run

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# List devices
flutter devices
```

### Tests

```bash
flutter analyze
flutter test
```

### Android APK (debug / local testing)

```bash
flutter build apk
```

Output typically: `build/app/outputs/flutter-apk/app-release.apk`  
Note: release signing currently uses **debug keys** (fine for internal testing, not store publish).

### iOS

```bash
flutter run -d ios
# or
flutter build ios
```

Requires macOS + Xcode. This cloud/Linux environment cannot build for a physical iPhone.

## Project structure

```text
lib/
  main.dart / app.dart
  core/theme/              # Design tokens
  navigation/              # Home · Create · Profile shell
  features/home/           # Home Feed
  features/create/         # Placeholder
  features/profile/        # Placeholder
  data/models/             # Playdate, Post, FeedItem, MomUser
  data/mock/               # Fictional mock feed
  shared/widgets/cards/    # BaseCard, PlaydateCard, PostCard
test/                      # Widget + unit tests
android/ ios/ web/         # Platform runners
docs/                      # Product notes
```

## Security

- MVP has **no API keys** or backend credentials  
- Copy [`.env.example`](.env.example) only if you add services later — never commit real secrets  
- Mock users in `lib/data/mock/` are **fictional**

## License / contribution

Private → public prep in progress. Contribution guide TBD after early user testing.
