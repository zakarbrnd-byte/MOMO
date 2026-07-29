# Data (MVP)

**No backend. No database yet.** Local mock only until Phase 4.0.

Current seed: `lib/data/mock_feed.dart` (legacy Playdate + Post).

## Target domain entities

| Entity | Role |
|--------|------|
| User | Account / identity |
| Group | Persistent community + members |
| Post | Discussion (feed and/or Group-scoped) |
| Comment | Thread under a Post |
| Event Announcement | Meetup inside a Group |
| RSVP | Joining / Not Joining |

## Current code entities (legacy foundation)

| Entity | Fields (summary) |
|--------|------------------|
| Playdate | id, title, date, time, location, childAge, description, hostName, … |
| Post | id, title, content, authorName, … |
| FeedItem | sealed wrapper for feed list |
| Profile | displayName, neighborhood, childInfo, bio |

Phase 3.7 introduces Group + Event local models. Schema decisions for Supabase belong in Phase 4.0.
