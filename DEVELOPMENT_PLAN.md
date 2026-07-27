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

## Phase 2 — Local state (Completed)

- [x] Connect Create flow to Home Feed
- [x] Riverpod providers for feed / create / profile
- [x] Local in-memory join / leave / ownership
- [x] Form validation and empty/error UX

---

## Phase 3.4 — Architecture freeze (Completed)

- [x] Repository + data source + DTO + DI layers
- [x] Freeze baseline (`docs/ARCHITECTURE_FREEZE.md`)

---

## Phase 3.5 — UI redesign (In progress)

Playdate-first Korean mom community (SoCal). MissyUSA-inspired content usefulness; not a forum clone.

- [x] Home hierarchy: CTA → upcoming playdates → popular → recent → categories → filtered feed
- [x] Feed filters + category discovery via providers
- [x] Playdate / Post card redesign + engagement metrics (display-only)
- [x] Detail + create visual refinement (Korean copy)
- [x] Mock engagement + category fields (reviewed model exception)
- [x] Tests + design docs

**Out of scope in 3.5:** interactive likes/comments/views, auth, Supabase, notifications, five-tab nav rewrite.

---

## Phase 4 — Future

- [ ] Authentication
- [ ] Backend database / API (Supabase)
- [ ] Real user profiles (edit, persistence)
- [ ] Real-time community features
- [ ] Interactive likes / comments / view tracking (when product scopes them)
