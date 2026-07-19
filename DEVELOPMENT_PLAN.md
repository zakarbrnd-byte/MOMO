# Development Plan

Status labels: **Completed** · **Next** · **Future**

---

## Phase 1 — App foundation (Completed)

Shipped in MVP 0.1:

- [x] Flutter app structure (`main.dart`, `app.dart`, theme)
- [x] Bottom navigation shell (Home · Create · Profile)
- [x] Home feed with mock Playdate + Post cards
- [x] Card UI components
- [x] Playdate / Post detail screens
- [x] Create selection screen
- [x] Create Playdate form (basic required-field validation)
- [x] Create Post form (basic required-field validation)
- [x] Profile placeholder screen
- [x] Local mock data (`lib/data/mock_feed.dart`)
- [x] Models: `Playdate`, `Post`, `FeedItem`
- [x] Riverpod dependency + root `ProviderScope` (no feature providers yet)

**Known gaps after Phase 1:**

- Create Save/Post does not update the Home feed (snackbar + pop only)
- Feed is static mock list
- No Join / RSVP
- Riverpod not used for feature state yet

---

## Phase 2 — Next development

Focus: make create/browse interactive with **local state**, still no backend.

- [ ] Connect Create flow to Home Feed (new items appear in feed)
- [ ] Implement Riverpod providers for feed / create / profile state
- [ ] Replace mock-only interaction with local in-memory state
- [ ] Improve form validation and error UX
- [ ] Add Join functionality for playdates (local state)
- [ ] UX/UI polish (spacing, empty states, feedback)

**Still out of scope in Phase 2:** auth, backend, chat, payments, marketplace.

---

## Phase 3 — Future

- [ ] Authentication
- [ ] Backend database / API
- [ ] Real user profiles (edit, persistence)
- [ ] Real-time community features

Order and stack for Phase 3 are TBD after Phase 2 validates local flows.
