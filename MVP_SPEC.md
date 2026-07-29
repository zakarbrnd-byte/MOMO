# MVP Spec

Canonical product scope for MOMO. If anything conflicts with older Playdate-first notes, **this file + `PROJECT_CONTEXT.md` win**.

---

## Target users

Korean mothers in the US with young children who want trusted local community — not cold 1-on-1 stranger meetups.

## Problem

Finding trusted parenting peers nearby is hard. Mothers generally feel uncomfortable meeting strangers one-on-one. They prefer joining an existing community first, building trust through membership and discussion, then meeting offline through activities organized inside that community.

## MVP purpose

Help Korean moms **discover and join Groups** based on shared interests, child age, and location; **participate in discussions**; and **organize Event Announcements** inside Groups.

```
MOMO
├── Community Feed
├── Groups
│      ├── Members
│      ├── Posts
│      └── Event Announcements
└── User Profiles
```

---

## Terminology

| Term | Definition |
|------|------------|
| **Group** | Persistent community. Not a scheduled event. |
| **Post** | Discussion content (feed and/or Group-scoped). |
| **Event Announcement** | Meetup created *inside* a Group (park, lunch, swim, library, etc.). |
| **RSVP** | Member response: Joining / Not Joining. |
| **Playdate** | Legacy name in current code for standalone meetup cards. Not the primary product surface going forward. |

### Event Announcement fields (target)

- Date, time, location, description, child age
- Optional participant limit
- RSVP: Joining / Not Joining
- Participant usernames displayed
- Reminder notifications — **future** (Phase 4.4)

---

## Scope

### Included (target MVP)

- Home / community feed
- Groups (browse, open, membership)
- Join Group / Leave Group
- Group Posts
- Comments
- Likes
- View tracking
- Event Announcements (inside Groups)
- RSVP
- User Profiles
- Search
- Filtering
- Korean & English Disclaimer

### Current shipped foundation (code today)

Phase 3.7 local Group-first UI:

- Bottom navigation: Home, Create, Profile
- Home feed with Group Cards + global Post cards
- Group Detail (posts, Event Announcements, members) + join/leave
- Event Detail with local RSVP
- Create Group / Create Post; Create Event from joined Group
- Repository + mock data-source architecture

Legacy Playdate screens may remain in the tree for dormant tests — not on active Home/Create.

### Out of scope

Do **not** build:

- Business marketplace / listings
- Payments
- AI recommendations
- Advanced moderation tooling
- Real-time chat
- Push notifications (until Phase 4.4)
- Advertising

### Future / phased (see DEVELOPMENT_PLAN.md)

| Area | Phase |
|------|-------|
| Group + Event local models | 3.7 |
| Recommendations, filter, search | 3.8 |
| Profile onboarding | 3.9 |
| Auth + Supabase | 4.0 |
| Comments / likes / views | 4.1 |
| Event Announcements + RSVP | 4.2 |
| Disclaimer / safety / reporting | 4.3 |
| Notifications | 4.4 |
| Pilot with real moms | 4.5 |

---

## Product principles

1. **Community first** — Groups before stranger meetups.
2. **Trust before logistics** — membership and discussion enable offline events.
3. **Event Announcements live inside Groups** — not standalone primary cards long-term.
4. **Scope discipline** — if it is not in this spec’s Included list (or the active phase in `DEVELOPMENT_PLAN.md`), do not build it yet.
5. **Simple > Complex** — local/mock validation before infrastructure where possible.

---

## Data entities

### Target domain (product direction)

- User
- Group (members)
- Post
- Comment
- Event Announcement
- RSVP

### Current code domain (legacy foundation)

- `Playdate`, `Post`, `FeedItem`, `User` / Profile, `Participant` — still present in Flutter models
- Do **not** rename classes in documentation-only phases; model migration starts Phase 3.7

See [ARCHITECTURE.md](ARCHITECTURE.md) for layering and intended domain diagram.
