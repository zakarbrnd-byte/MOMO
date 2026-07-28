# MVP Features

Canonical detail: [`../MVP_SPEC.md`](../MVP_SPEC.md).

## Status: Phase 3.5 UI redesign (local mock)

### Core product

MOMO is a mobile community for Korean moms in Southern California to:

- Create and join **real playdates**
- Ask and browse **parenting / local community posts**

Playdate remains the primary feature; community posts support everyday questions.

### Implemented

- Bottom nav: 홈 · 만들기 · 프로필
- Home (playdate-first):
  - Compact MOMO app bar + search/notification icons (UI affordances only)
  - Feed filters: 전체 / 플레이데이트 / 육아톡
  - Playdate hero CTA → create playdate flow
  - Upcoming playdates section
  - Category discovery chips (functional filter via providers)
  - Popular posts (`오늘 많이 보는 글`) and recent posts (`새로 올라온 글`)
  - Mixed filtered feed
- Redesigned Playdate + Post cards with engagement metrics (display-only)
- Detail screens aligned with card presentation
- Create selection + Koreanized Playdate / Post forms (post category)
- Join / leave / ownership / capacity states (local Riverpod + repositories)
- Mock feed: ≥8 playdates, ≥12 posts, SoCal Korean mom content

### Explicitly excluded / deferred

Business listings, marketplace, chat, payments, **interactive** comments/likes/views, photos, search backend, notifications backend, complex matching, auth, Supabase/backend.

Comment / like / view counts are shown from mock fields only — no real interaction in this phase.
