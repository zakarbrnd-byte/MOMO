# MOMO MVP Status

**Date:** 2026-07-18  
**Version:** MVP 0.1  
**Audience:** Public repo / early device testing  

This file tracks what is actually implemented vs what is still needed before recruiting ~5 moms for feedback.

---

## Completed

| Item | Notes |
|------|--------|
| Flutter project platforms (`android/`, `ios/`, `web/`) | Runnable |
| Design system tokens | Colors, type, spacing, card/button styles |
| `BaseCard` shared chrome | Rounded, bordered, tappable shell |
| `PlaydateCard` | Title, when, where, ages, host |
| `PostCard` | Title, body preview, relative time, author |
| Home Feed | Vertical scroll, mixed mock cards |
| Bottom navigation | Home · Create · Profile |
| Mock data layer | Fictional SoCal moms / playdates / posts |
| Automated tests | Analyze clean; widget/unit tests for feed, cards, shell, format |
| Profile tab shell | Placeholder screen only |
| Create tab shell | Placeholder screen only |

---

## Needs Fix Before Testing

Prioritized for **real-device UI testing** and first mom feedback sessions.

| Item | Why it blocks / hurts testing | Priority |
|------|-------------------------------|----------|
| **Create flow missing** | Create tab is a placeholder — moms cannot post a playdate/post | High for “create” feedback; OK to skip if testing browse-only |
| **Detail screens missing** | Cards do not open Playdate/Post detail | High for “tap a card” feedback |
| **Card taps not wired** | `onTap` exists on cards but Home does not navigate | Same as details |
| **English-only UI** | Product targets Korean moms; copy/dates are English | Medium — may confuse early Korean users |
| **Profile is empty placeholder** | Cannot show “my cards” or basic identity | Medium |
| **Android release uses debug signing** | Fine for sideload testing; not for Play Store | Low for internal APK tests |
| **No Korean localization** | Same as English-only | Medium |

### Recommended testing slice (now)

Safe to test **today** without more features:

1. Install / open app  
2. Browse Home Feed  
3. Scroll mixed Playdate + Post cards  
4. Switch Home · Create · Profile tabs (Create/Profile will look unfinished — set expectations)  

Do **not** promise create/RSVP/detail in this build.

---

## Future Features

Explicitly **out of current MVP** (do not build before feed validation):

- Auth / accounts  
- Supabase or any backend  
- Chat / messaging  
- Push notifications  
- Business listings  
- Payments  
- Advanced matching algorithm  
- Comments, photos, search  
- Complex community features  

### After feed validation (still mock-first)

1. Create Selection → Create Playdate / Create Post  
2. Playdate Detail / Post Detail  
3. Profile with mock user + their cards  
4. Korean (or bilingual) copy pass  

---

## Scope reminder

From product rules:

- Everything is a Card  
- Two card types only  
- Mock data first  
- No backend initially  
- Every feature must help moms connect offline  
