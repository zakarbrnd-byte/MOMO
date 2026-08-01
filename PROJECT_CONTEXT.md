# PROJECT_CONTEXT

**Single source of truth** for product direction. Read this before inventing scope.

Agents: prefer this file + `CLAUDE.md` + `MVP_SPEC.md` over older Playdate-first wording elsewhere.

---

## Product

**MOMO** — community app for Korean mothers in the US.

**Vision:** Help Korean mothers discover and join communities based on shared interests, child age, and location — then organize activities together inside those communities.

Version: MVP 0.1  
Current phase: **Launch Sprint 1.1 Post comments (local)** shipped → **3.9 / likes & push next**

---

## Product pivot (why)

Interview finding with real mothers:

| Finding | Product implication |
|---------|---------------------|
| Uncomfortable meeting strangers 1-on-1 | Do not lead with standalone stranger meetups |
| Prefer joining an existing community first | **Groups** are the primary destination |
| Trust builds inside communities | Membership and discussion before meetups |
| Meetups happen naturally afterwards | **Event Announcements** live *inside* Groups |

**Old vision:** Help Korean mothers discover and create local playdates.  
**New vision:** Help Korean mothers discover and join Groups; Event Announcements are organized activities inside Groups.

The Playdate-first MVP remains valuable as **engineering foundation** (Flutter shell, Riverpod, repositories, mock DI). It is **not** the long-term product shape.

---

## Core product structure

```
MOMO
├── Community Feed
├── Groups
│      ├── Members
│      ├── Posts
│      └── Event Announcements
└── User Profiles
```

### Terminology

| Term | Meaning |
|------|---------|
| **Group** | Persistent community (e.g. Irvine Moms, Swimming Moms). Not a scheduled event. |
| **Post** | Community discussion (global feed and/or inside a Group) |
| **Event Announcement** | Meetup created inside an existing Group (date, time, location, RSVP) |
| **Playdate** | Historical / current code name for standalone meetup cards. Treat as legacy until Group + Event models replace it. |

Example Groups: LA Moms with 3-year-olds · Swimming Moms · Irvine Moms · Korean Working Moms · Preschool Moms · Hiking Moms.

---

## Intended domain (before backend)

```
User
 ↓
Group
 ↓
Post
 ↓
Comment
 ↓
Event Announcement
 ↓
RSVP
```

Engineering layers (UI → Riverpod → Repository → Data Source) stay. Domain entities will expand in Phase 3.7+.

---

## What exists in code today

- Flutter + Material 3 + design system
- Bottom nav: Home / Create / Groups / Profile
- Riverpod + repository + mock data-source DI
- **Active UI:** Group Cards on Home, content-first Group Detail (Posts/Events/Members), Group Information (join/leave + create event), Event Detail + RSVP, Create Group / Post
- Group providers await repository Futures (no `_readSync`); membership via `loadJoinedGroupIds`
- Global + Group-scoped Posts (`Post.groupId`)
- **Post comments + one-level replies** (local mock): flat `Comment` + `parentCommentId`; count includes replies; reply-to-reply attaches to thread root
- Legacy Playdate stack may remain for dormant unit paths — **not** on active Home/Create
- DTOs, `Result`, mutation lifecycle

**Backend is not connected.** All Group/Event/RSVP/Comment state is local mock (no multi-user persistence).

---

## MVP target scope (Group-first)

See `MVP_SPEC.md` for full in/out lists.

**In:** Home feed, Groups (join/leave), Group posts, comments, likes, view tracking, Event Announcements, RSVP, profiles, search, filtering, Korean & English disclaimer.

**Out:** Marketplace, payments, AI recommendations, advanced moderation, real-time chat, push notifications (until later phase), advertising.

---

## Roadmap (summary)

| Phase | Focus |
|-------|--------|
| 3.6 | Documentation pivot (**done**) |
| 3.7 | Group + Event local models (**done**) |
| 3.8 | Home recommendations, filtering, search (**done**) |
| Sprint 1.1 | Post comments + one-level replies, local mock (**done**) |
| 3.9 | Profile onboarding (**next**) |
| 4.0 | Auth + Supabase |
| 4.1 | Comment likes, post likes, view tracking (comments UI already local) |
| 4.2 | Event Announcements + RSVP |
| 4.3 | Disclaimer, safety, reporting |
| 4.4 | Notifications |
| 4.5 | Pilot with real moms |

Canonical detail: `DEVELOPMENT_PLAN.md`.

---

## Architecture freeze status

The Phase 3.4.8 Architecture Freeze described the **Playdate-first** engineering baseline and is **superseded** for product direction.

- Historical freeze: `docs/ARCHITECTURE_FREEZE.md` (read-only context)
- Live engineering detail: `ARCHITECTURE.md`
- Product baseline: **this file** + `MVP_SPEC.md`

Layer patterns (UI → Provider → Repository → Data Source) remain the intended engineering approach. Domain models will change for Groups.

---

## Docs map

| Doc | Use for |
|-----|---------|
| `PROJECT_CONTEXT.md` | Product truth (this file) |
| `MVP_SPEC.md` | Scope in / out |
| `DEVELOPMENT_PLAN.md` | Phased roadmap |
| `ARCHITECTURE.md` | Code layers + intended domain |
| `README.md` | Overview, run, status |
| `CLAUDE.md` | Agent operating rules |
| `BACKEND_MIGRATION_CHECKLIST.md` | Pre-Supabase engineering checklist |
