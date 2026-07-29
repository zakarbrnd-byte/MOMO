# Development Plan

Status labels: **Completed** · **Current** · **Next** · **Future**

Product direction is **Group-first**. See `PROJECT_CONTEXT.md` and `MVP_SPEC.md`.

---

## Completed foundation (Phases 1–3.5)

Shipped as the Playdate-shaped technical MVP:

- [x] Flutter app structure, theme, bottom navigation
- [x] Home feed with mock Playdate + Post cards
- [x] Create / detail / join-leave local flows
- [x] Riverpod + repository + mock data-source DI
- [x] DTOs, `Result`, mutation lifecycle
- [x] Phase 3.5 card UI / metadata polish

This foundation is reused; it is not the final product surface.

---

## Phase 3.6 — Product Pivot & Documentation Refresh (**Completed**)

- [x] Redefine vision around Groups and Event Announcements
- [x] Update README, MVP_SPEC, PROJECT_CONTEXT, DEVELOPMENT_PLAN, ARCHITECTURE, agent docs
- [x] Retire Playdate-first Architecture Freeze as product baseline

---

## Phase 3.7 — Group + Event local models (**Completed**)

- [x] Domain models: Group, GroupMember, EventAnnouncement, RSVP; Post.groupId
- [x] DTOs + mock data (LA/OC Korean mom communities)
- [x] Group repository / data source + Riverpod providers
- [x] Home Group Cards + global Posts (Playdate retired from active Home/Create)
- [x] Group Detail (posts, events, members) + local join/leave
- [x] Event Detail + local RSVP (참석 / 불참)
- [x] Create Group; Create Event from joined Group Detail
- [x] Tests for domain, feed, group flows

**Still local/mock only — no backend, auth, or persistence.**

---

## Phase 3.8 — Home recommendations, Filtering, Search (**Next**)

- [ ] Home recommendations for Groups / feed items
- [ ] Filtering (interest, child age, location)
- [ ] Search

---

## Phase 3.9 — Profile onboarding

- [ ] Profile onboarding flow (location, child age, interests)
- [ ] Tie profile signals to Group discovery

---

## Phase 4.0 — Authentication & Supabase

- [ ] Authentication
- [ ] Supabase (or equivalent) persistent backend
- [ ] Replace mock data sources via DI overrides

---

## Phase 4.1 — Comments, Likes, View tracking

- [ ] Comments
- [ ] Likes
- [ ] View tracking

---

## Phase 4.2 — Event Announcements & RSVP

- [ ] Create Event Announcement inside a Group
- [ ] RSVP: Joining / Not Joining
- [ ] Show participant usernames

---

## Phase 4.3 — Disclaimer, Safety, Reporting

- [ ] Korean & English Disclaimer
- [ ] Safety / reporting basics

---

## Phase 4.4 — Notifications

- [ ] Reminder / engagement notifications (product-appropriate channels)

---

## Phase 4.5 — Pilot testing with real moms

- [ ] Pilot with interview cohort / local moms
- [ ] Capture feedback against Group-first experience

---

## Explicitly not on this roadmap

Marketplace, payments, AI recommendations, advanced moderation, real-time chat, advertising.
