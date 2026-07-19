# Data (MVP)

**No backend. No database.** Local mock only.

Source: `lib/data/mock_feed.dart`

## Mock entities

| Entity | Fields (summary) |
|--------|------------------|
| Playdate | id, title, date, time, location, childAge, description, hostName |
| Post | id, title, content, authorName |
| FeedItem | sealed wrapper for feed list |
| Profile | displayName, neighborhood, childInfo, bio |

Phase 3 may introduce a real database; do not design schema work into Phase 1–2 unless needed for local state.
