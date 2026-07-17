# Architecture

## Stack (current)

- **Flutter** (Material 3)
- **Mock data only** — no backend, no auth
- **`flutter_riverpod`** — dependency present; app root wraps `ProviderScope`
- **No Riverpod providers yet** — nothing uses `ref.watch` / `ConsumerWidget`

## State today

- Bottom-tab index: local `setState` in `MainShell`
- Home Feed: static `MockFeed.items` read directly by `HomeFeedScreen`
- No repository layer
- No router / named routes (shell `home:` only)

## Rules

- No backend for MVP
- Do not over-engineer
- Add providers/repositories only when Create needs shared mutable feed state
