# Design System

Implemented in `lib/core/theme/` and shared widgets under `lib/core/widgets/`.

## Product direction (Phase 3.5)

MOMO is a **playdate-first Korean mom community** for Southern California moms.

Visual/UX references (inspiration only — do not copy layouts):

- MissyUSA — natural Korean community topics and practical everyday posts
- Peanut — warmth and human identity
- Meetup — clear event info and participation decisions
- Modern mobile apps — simple navigation and readable cards

Mood: Korean-first, local, warm, practical, community-driven.

## Direction

- Warm pink / soft coral primary (`AppColors.primary`)
- Cream / soft warm off-white background (`AppColors.background`)
- Warm gray metadata; white card surfaces
- Rounded cards with light borders (moderate radius, subtle elevation)
- Large, readable typography via `AppTextStyles`
- Prefer clarity over decorative chrome

## Typography hierarchy (MVP)

| Role | Size | Weight |
|------|------|--------|
| Screen / wordmark | 20–24sp | bold |
| Section title | 16–18sp | semibold |
| Card title | 15–17sp | semibold |
| Body | 14–15sp | regular |
| Metadata | 12–13sp | regular |

Do not hardcode repeated text styles in feature widgets — use `AppTextStyles`.

## Home information hierarchy

1. Playdate creation CTA (`PlaydateHeroCta`)
2. Nearby / upcoming Playdates
3. Popular parenting posts (`오늘 많이 보는 글`)
4. New community posts (`새로 올라온 글`)
5. Category discovery chips
6. Filtered mixed feed (전체 / 플레이데이트 / 육아톡)

## Cards

- **Playdate:** type label, title, date/time, location, child age, host, capacity, join state, engagement row
- **Post:** category label, title, 2–3 line preview, author + location/context, time, engagement row

Engagement metrics (views / comments / likes) are **display-only** in Phase 3.5 — use `EngagementRow`.

## UI rules (MVP)

- Cards are the main interaction surface on Home and Create
- Mobile-first layout; also run on Flutter Web for development
- Avoid dense forum title lists, banner-heavy layouts, dating-app swipe UX
- Bottom nav remains three functional tabs: 홈 · 만들기 · 프로필
