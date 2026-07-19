# MVP Spec

## Target users

Korean mothers in the US with young children who want offline, local connections with other moms.

## Problem

Finding trusted playdates and parenting peers nearby is hard. Existing apps are either too broad or too heavy. Moms need a simple place to:

1. Discover local playdates
2. Create a playdate invitation
3. Share short parenting posts

## MVP purpose

Help Korean moms **discover and create local playdates** and **share parenting-related posts**.

Core product principle: **Everything is a Card.**

Card types (only):

1. Playdate Card
2. Post Card

## MVP scope (current)

### Included

- Bottom navigation: Home, Create, Profile
- Home feed with mock Playdate and Post cards
- Tap card → detail screen
- Create selection → Create Playdate / Create Post forms
- Profile screen with placeholder mock user info
- Local mock data only (no backend)

### Implemented screens

| Screen | Role |
|--------|------|
| Home Feed | Mixed card list |
| Create Selection | Two large action cards |
| Create Playdate | Title, Date, Time, Location, Child Age, Description, Save |
| Create Post | Title, Content, Post |
| Playdate Detail | Full playdate fields |
| Post Detail | Title + content |
| Profile | Mock name, neighborhood, child info, bio |

### Data entities (mock)

- `Playdate` — id, title, date, time, location, childAge, description, hostName
- `Post` — id, title, content, authorName
- Feed items — sealed `FeedItem` (`PlaydateFeedItem` / `PostFeedItem`)
- Mock profile record — display name, neighborhood, child info, bio

## Excluded from MVP

Do **not** build these in the current MVP:

- Business listings / marketplace
- Chat / messaging
- Payments
- Comments, likes, photos, search
- Notifications
- Complex matching algorithms
- Community tabs beyond Home / Create / Profile
- Authentication
- Backend database / APIs
- Real-time sync

## Future possibilities (out of MVP)

Listed for orientation only — not current work:

- Auth and real user accounts
- Persistent backend
- Join / RSVP for playdates
- Richer profiles
- Location-aware discovery
- Real-time community features

See [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) for phased sequencing.
