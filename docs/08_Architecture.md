# Architecture

## Stack (current)

- **Flutter** (Material 3)
- **Mock data only** — no backend, no auth
- **Riverpod** — `feedProvider`, `currentUserProvider`, `tabIndexProvider`

## State

- Feed: `StateNotifier` seeded from `MockFeed.items`; Create prepends cards
- Tabs: `tabIndexProvider`
- Current user: mock `MockUsers.soojin`

## Navigation

- Bottom tabs: Home · Create · Profile
- Nested `Navigator` per tab for Detail / Create forms

## Rules

- No backend for MVP
- Do not over-engineer
