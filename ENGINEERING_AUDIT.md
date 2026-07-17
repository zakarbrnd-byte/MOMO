# MOMO Engineering Audit

**Role:** Lead Flutter Engineer  
**Date:** 2026-07-17  
**Scope:** Entire repository (application code, tests, platforms, docs, config)  
**Method:** Full read of tracked sources; `flutter analyze` clean; `flutter test` 14/14 passing  
**Constraint:** Audit only — no application code was written or modified for this document.

---

## 0. Executive verdict

MOMO is a **healthy early MVP foundation** with an unusually strong design-system and card layer for its size (~22 Dart files in `lib/`, ~1.3k LOC). The Home Feed correctly embodies **“Everything is a Card.”**

It is **not yet a complete MVP** per `CLAUDE.md`. Create / Detail / Profile flows are missing or placeholders. Architecture docs claim Riverpod; the app only wraps `ProviderScope` and uses local `setState` + static mocks. Product copy is English/SoCal while the product targets Korean mothers.

**Ship readiness for documented MVP:** incomplete.  
**Ship readiness for current scoped slice (browse mock feed):** good.

---

## 1. System snapshot

| Area | Current state |
|------|----------------|
| Product | Playdate matching for Korean moms (`CLAUDE.md`) |
| Stack | Flutter 3.x · Material 3 · `flutter_riverpod` (declared) · mock data |
| Navigation | Bottom tabs only (`MainShell` + `IndexedStack`) |
| Screens implemented | Home Feed (real); Create (placeholder); Profile (placeholder) |
| Screens missing | Create Selection, Create Playdate, Create Post, Playdate Detail, Post Detail, real Profile |
| Cards | `BaseCard` → `PlaydateCard` / `PostCard` |
| Data | Immutable models + `MockFeed` static list |
| Tests | 4 files, 14 tests — design system, cards, home feed, smoke |
| Platforms | `android/`, `ios/`, `web/` present |
| Analyze / Test | Clean / all passing |

### Architecture as implemented

```text
main.dart
  └─ ProviderScope          ← Riverpod root only; no providers
       └─ MomoApp
            └─ MaterialApp(theme: AppTheme.light, home: MainShell)
                 └─ IndexedStack
                      ├─ HomeFeedScreen  → MockFeed → PlaydateCard / PostCard
                      ├─ CreatePlaceholderScreen
                      └─ ProfilePlaceholderScreen
```

There is **no** router, repository, auth, network, or persistence layer.

---

## 2. Strengths (keep)

1. **Clear folder layout** — `core/`, `data/`, `features/`, `navigation/`, `shared/` is appropriate and scalable for the next MVP screens.
2. **Design tokens are real** — colors, type, spacing, card, and button styles live in `lib/core/theme/` and compose into `AppTheme.light`.
3. **Card reuse is excellent** — shared shell + chrome enforce one design language; sealed `FeedItem` keeps feed rendering exhaustive.
4. **Mock-first discipline** — no backend/auth packages; aligns with CLAUDE.md “mock data first / no backend.”
5. **Test seams exist** — `HomeFeedScreen(items:, now:)` and `PostCard(now:)` are injectable; widget tests exercise the important paths.
6. **Low security surface** — no secrets in source; `.env*` ignored; no network permissions/features yet.
7. **Quality bar** — analyze clean, const-friendly widgets, stable `ValueKey`s on feed rows, `CustomScrollView` + `SliverList`.

---

## 3. Issue register

Severity scale:

- **Critical** — blocks core product loop or creates serious risk if ignored now  
- **High** — major MVP / architecture gap; should be next work  
- **Medium** — quality, consistency, or maintainability debt  
- **Low** — polish / future-proofing  

Effort estimates are **implementation effort for one experienced Flutter engineer** (hours), not calendar schedule.

---

### A. Product consistency with `CLAUDE.md`

#### A1. Incomplete MVP screen set

| Field | Detail |
|-------|--------|
| **Description** | `CLAUDE.md` requires Home Feed, Create Selection, Create Playdate, Create Post, Playdate Detail, Post Detail, Profile. Only Home Feed is real; Create/Profile are placeholders; Selection + Create forms + Details do not exist. |
| **Why it matters** | Documented product loop (browse → detail; create → feed) cannot be completed. Success metrics in docs assume playdates/posts being created. |
| **Severity** | **Critical** |
| **Recommended solution** | Implement remaining screens with mock-only writes (in-memory feed mutation). Keep two card types only. No backend. |
| **Estimated time** | 12–20 hours (screens + wiring + basic tests) |

#### A2. Card taps do not advance the browse flow

| Field | Detail |
|-------|--------|
| **Description** | `PlaydateCard` / `PostCard` support `onTap`, but `HomeFeedScreen` never passes handlers. Docs require Home → Detail. |
| **Why it matters** | Feed is browse-only; offline connection intent (“discover playdates”) stops at the list. |
| **Severity** | **Critical** |
| **Recommended solution** | Add detail screens and wire `onTap` → navigate by id. Use a thin router (named routes or `go_router`). |
| **Estimated time** | 4–8 hours (details + navigation) |

#### A3. Locale / audience mismatch

| Field | Detail |
|-------|--------|
| **Description** | Product targets Korean mothers; UI strings, `CardFormat`, and mock content are English + SoCal neighborhoods. `CardAuthorRow` initials logic is Western whitespace-name oriented. |
| **Why it matters** | Weak product authenticity; Korean display names / Hangul will format poorly. |
| **Severity** | **High** |
| **Recommended solution** | Korean-first (or bilingual) copy; `intl` / localization delegates; mock data reflecting persona; improve initials/avatar fallback for Hangul. |
| **Estimated time** | 6–10 hours for first localization pass + mock refresh |

#### A4. Docs overstate implemented state

| Field | Detail |
|-------|--------|
| **Description** | `docs/03`, `04`, `08`, README describe Riverpod architecture and full flows as if present. |
| **Why it matters** | Misleads contributors; review/planning noise. |
| **Severity** | **Medium** |
| **Recommended solution** | Mark each screen/flow as Done / Next / Out of scope. Align `08_Architecture.md` with actual state management. |
| **Estimated time** | 1–2 hours |

---

### B. Project architecture & folder structure

#### B1. No application layer between UI and mocks

| Field | Detail |
|-------|--------|
| **Description** | `HomeFeedScreen` imports `MockFeed` directly. No repository, service, or provider boundary. |
| **Why it matters** | Create flows that mutate the feed, and any later backend, will force screen rewrites. |
| **Severity** | **High** |
| **Recommended solution** | Introduce `FeedRepository` (mock impl now) + Riverpod provider(s) OR a simple inherited/controller seam. UI depends on abstraction only. |
| **Estimated time** | 2–4 hours |

#### B2. Riverpod declared but unused

| Field | Detail |
|-------|--------|
| **Description** | `ProviderScope` in `main.dart`; zero providers/`ConsumerWidget`/`ref.watch` in `lib/`. Docs claim Riverpod. |
| **Why it matters** | Architecture fiction; unused dependency; confusion on where state should live. |
| **Severity** | **High** |
| **Recommended solution** | Either (preferred) add `feedProvider` + create mutations now, **or** remove Riverpod until shared state is needed (valid under “do not over-engineer”). Pick one and update docs. |
| **Estimated time** | 1–3 hours (adopt or remove) |

#### B3. Feature folders not ready for detail/create growth

| Field | Detail |
|-------|--------|
| **Description** | Only `features/home|create|profile`. Detail/create forms will need clearer ownership (`features/playdate/`, `features/post/`, or nested under create/home). |
| **Why it matters** | Without a convention, screens will sprawl under home/create. |
| **Severity** | **Medium** |
| **Recommended solution** | Before building next screens, decide feature ownership map in README/`CLAUDE.md` and follow it. |
| **Estimated time** | 0.5–1 hour (decision + light moves as screens land) |

#### B4. Folder structure itself is sound

| Field | Detail |
|-------|--------|
| **Description** | Current split is a strength, not a defect. |
| **Why it matters** | — |
| **Severity** | **Low** (observation) |
| **Recommended solution** | Keep; grow features under `features/*` and shared widgets under `shared/`. |
| **Estimated time** | — |

---

### C. Flutter best practices

#### C1. No routing layer

| Field | Detail |
|-------|--------|
| **Description** | `MaterialApp(home: MainShell)` only. No `routes`, `onGenerateRoute`, or `go_router`. Nested Navigator for feed→detail absent. |
| **Why it matters** | Detail/create flows need stack navigation; deep links later need a map. |
| **Severity** | **High** |
| **Recommended solution** | Add lightweight routing now (shell + nested stack for Home). Prefer `go_router` if multiple stacks grow; named routes acceptable for MVP. |
| **Estimated time** | 3–5 hours |

#### C2. `BaseCard` bypasses themed `Card`

| Field | Detail |
|-------|--------|
| **Description** | Cards use `Material` + `AppCardStyle` manually while `ThemeData.cardTheme` is configured but unused by feed cards. |
| **Why it matters** | Dual sources of truth for card chrome; theme tweaks may not affect real UI. |
| **Severity** | **Medium** |
| **Recommended solution** | Either build `BaseCard` on Flutter `Card` (consume theme) or document `BaseCard` as the sole card chrome API and stop relying on `cardTheme` for feed. |
| **Estimated time** | 1–2 hours |

#### C3. Magic numbers outside tokens

| Field | Detail |
|-------|--------|
| **Description** | e.g. label radius `8`, icon `18`, avatar `14` in `card_chrome.dart`; chip/input/snackbar radii/`64` nav height in `app_theme.dart`. |
| **Why it matters** | Design consistency erodes as more screens copy literals. |
| **Severity** | **Low** |
| **Recommended solution** | Promote to `AppSpacing` / radius tokens as chrome is touched. |
| **Estimated time** | 1–2 hours |

#### C4. Placeholder screens ignore design system richness

| Field | Detail |
|-------|--------|
| **Description** | Create/Profile use bare `Scaffold` + `headlineMedium` only. |
| **Why it matters** | Temporary; becomes debt if placeholders linger while polish continues elsewhere. |
| **Severity** | **Low** |
| **Recommended solution** | Replace with real screens rather than polishing placeholders. |
| **Estimated time** | Covered by A1 |

---

### D. Reusable widgets

#### D1. Card system is strong; body scaffold still duplicated

| Field | Detail |
|-------|--------|
| **Description** | `PlaydateCard` and `PostCard` share shell/chrome but repeat label→title→meta→author structure. |
| **Why it matters** | Fine for 2 types; a third type would amplify duplication. CLAUDE.md forbids more card types for now. |
| **Severity** | **Low** |
| **Recommended solution** | Extract only if a third card type is approved (it should not be for MVP). |
| **Estimated time** | 1–2 hours if needed |

#### D2. Missing shared empty / loading / error widgets

| Field | Detail |
|-------|--------|
| **Description** | Empty state is private to Home; no loading/error patterns (acceptable while sync). |
| **Why it matters** | Create/detail will need consistent empty/error UX soon. |
| **Severity** | **Medium** |
| **Recommended solution** | Add minimal `EmptyState` shared widget when second screen needs it—not before. |
| **Estimated time** | 1–2 hours |

#### D3. Button styles unused in product UI

| Field | Detail |
|-------|--------|
| **Description** | `AppButtonStyle` is themed but no screen uses primary/secondary CTAs yet. |
| **Why it matters** | Create/Detail will be the first real consumers; risk of redesign-on-first-use. |
| **Severity** | **Low** |
| **Recommended solution** | Validate button styles in Create forms when built; adjust once with real content. |
| **Estimated time** | 1 hour (during Create work) |

---

### E. Design system & theme consistency

#### E1. Warm/minimal/rounded/large type — mostly consistent on Home

| Field | Detail |
|-------|--------|
| **Description** | Home + cards match `docs/06_Design_System.md`. Placeholders do not demonstrate the system. |
| **Why it matters** | Design language only proven on one surface. |
| **Severity** | **Medium** |
| **Recommended solution** | Apply same tokens on Create/Detail/Profile as they are built. |
| **Estimated time** | Included in feature work |

#### E2. Platform default font; no Korean typography choice

| Field | Detail |
|-------|--------|
| **Description** | `AppTypography.fontFamily = null`. |
| **Why it matters** | Acceptable MVP; may look generic for Hangul-heavy UI later. |
| **Severity** | **Low** |
| **Recommended solution** | Choose a Korean-friendly font when branding hardens; keep warm/minimal. |
| **Estimated time** | 2–4 hours (font pick + asset wiring) |

#### E3. Unused / dual-path tokens

| Field | Detail |
|-------|--------|
| **Description** | `AppColors.success` unused; button text styles duplicate foreground colors; `cardTheme` vs `BaseCard` dual path (see C2). |
| **Why it matters** | Minor hygiene. |
| **Severity** | **Low** |
| **Recommended solution** | Opportunistic cleanup when touching theme files. |
| **Estimated time** | 0.5–1 hour |

---

### F. State management

#### F1. Actual state model is local + static

| Field | Detail |
|-------|--------|
| **Description** | Tab index via `setState` in `MainShell`. Feed is immutable static `MockFeed.items`. No mutable app state. |
| **Why it matters** | Create → appear on Home requires shared mutable feed state. |
| **Severity** | **High** |
| **Recommended solution** | Introduce a single feed listenable/provider owned above shell; Create appends; Home watches. Keep mock-only. |
| **Estimated time** | 3–5 hours |

#### F2. `IndexedStack` retains all tabs

| Field | Detail |
|-------|--------|
| **Description** | All three tab trees stay alive. |
| **Why it matters** | Fine for light placeholders; Create forms with controllers may retain memory/state unexpectedly. |
| **Severity** | **Low** |
| **Recommended solution** | Revisit if Create becomes heavy; consider disposing offstage tabs or nested navigators carefully. |
| **Estimated time** | 1–2 hours if needed |

---

### G. Navigation

#### G1. Bottom nav matches CLAUDE.md; stack navigation missing

| Field | Detail |
|-------|--------|
| **Description** | Home · Create · Profile tabs exist and match CLAUDE.md. No nested routes for Selection/Create forms/Details. |
| **Why it matters** | Blocks A1/A2. |
| **Severity** | **Critical** (same root cause as incomplete flows) |
| **Recommended solution** | Shell stays; each tab gets a nested `Navigator` or go_router branches. |
| **Estimated time** | 3–5 hours (with C1) |

#### G2. No back-stack / deep-link strategy

| Field | Detail |
|-------|--------|
| **Description** | Not required for mock MVP, but absent. |
| **Why it matters** | Will matter for shareable playdate links later. |
| **Severity** | **Low** |
| **Recommended solution** | Defer until after MVP screens; choose router with path params when needed. |
| **Estimated time** | — (defer) |

---

### H. Naming consistency

#### H1. Generally consistent

| Field | Detail |
|-------|--------|
| **Description** | snake_case files, PascalCase types, stable Playdate/Post/MomUser vocabulary. |
| **Severity** | — (strength) |
| **Recommended solution** | Keep. |
| **Estimated time** | — |

#### H2. Generic `Post` type name

| Field | Detail |
|-------|--------|
| **Description** | `Post` is overloaded in many codebases. |
| **Why it matters** | Collision/confusion as imports grow. |
| **Severity** | **Low** |
| **Recommended solution** | Rename to `MomPost` / `FeedPost` only if pain appears. |
| **Estimated time** | 0.5–1 hour |

#### H3. `card_chrome.dart` grab-bag naming

| Field | Detail |
|-------|--------|
| **Description** | File hosts label, meta row, author row. |
| **Why it matters** | Mild discoverability issue. |
| **Severity** | **Low** |
| **Recommended solution** | Split only if file grows; optional rename to `card_atoms.dart`. |
| **Estimated time** | 0.5 hour |

---

### I. Mock data architecture

#### I1. Static global list is demo-friendly but not write-ready

| Field | Detail |
|-------|--------|
| **Description** | `MockFeed.items` is a top-level `static final List`. Good for demos/tests; Create cannot append without mutating a global or replacing architecture. |
| **Why it matters** | Blocks realistic create→feed loop. |
| **Severity** | **High** |
| **Recommended solution** | Move to repository holding a mutable list / `StateNotifier`; seed from current mock constants. |
| **Estimated time** | 2–3 hours (with B1/F1) |

#### I2. Fixed `MockFeed.now` clock

| Field | Detail |
|-------|--------|
| **Description** | Stable clock helps demos/tests; relative times never move in production runs. |
| **Why it matters** | Confusing in long-lived debug sessions; fine for MVP demos. |
| **Severity** | **Low** |
| **Recommended solution** | Use `DateTime.now()` in app; keep injectable `now` for tests. |
| **Estimated time** | 0.5 hour |

#### I3. No model equality / serialization

| Field | Detail |
|-------|--------|
| **Description** | Models lack `==`/`hashCode`/`copyWith`/JSON. |
| **Why it matters** | Not needed until caching/backend; acceptable under do-not-over-engineer. |
| **Severity** | **Low** |
| **Recommended solution** | Add when repository mutations or persistence appear (`Equatable`/`freezed` optional). |
| **Estimated time** | 2–4 hours when needed |

---

### J. Test coverage

#### J1. Good coverage for current implemented slice

| Field | Detail |
|-------|--------|
| **Description** | Design tokens, card rendering/taps, mixed feed, empty state, app smoke — 14 passing tests. |
| **Severity** | — (strength) |
| **Estimated time** | — |

#### J2. Missing shell / format / a11y / flow tests

| Field | Detail |
|-------|--------|
| **Description** | No tests for tab switching; no unit tests for `CardFormat`; no semantics assertions; no create/detail flows (features absent). |
| **Why it matters** | Regressions likely as navigation lands. |
| **Severity** | **Medium** |
| **Recommended solution** | Add `MainShell` tab test + `CardFormat` unit tests now; add flow tests with each new screen. |
| **Estimated time** | 2–3 hours now; +1–2 hours per new screen |

#### J3. No golden tests for card design language

| Field | Detail |
|-------|--------|
| **Description** | Card UI is brand-critical; no golden/snapshot tests. |
| **Why it matters** | Visual regressions possible. |
| **Severity** | **Low** |
| **Recommended solution** | Optional goldens for `PlaydateCard`/`PostCard` once design freezes. |
| **Estimated time** | 2–4 hours |

---

### K. Performance

#### K1. Adequate for current data size

| Field | Detail |
|-------|--------|
| **Description** | Sliver list, const usage, no images/network, ~8 mock items. |
| **Severity** | — (strength) |
| **Estimated time** | — |

#### K2. Minor allocation churn (not urgent)

| Field | Detail |
|-------|--------|
| **Description** | Theme getters rebuild `ThemeData`/`ButtonStyle`; `withValues` splash colors; string formatting each build. |
| **Why it matters** | Negligible at current scale. |
| **Severity** | **Low** |
| **Recommended solution** | Cache theme if cold-start profiling ever warrants; otherwise ignore. |
| **Estimated time** | — (defer) |

---

### L. Accessibility

#### L1. Partial semantics on cards

| Field | Detail |
|-------|--------|
| **Description** | `BaseCard` sets `Semantics(button, label)` when tappable. Home feed cards are not tappable today, so they are not exposed as buttons. Meta icons lack semantic labels; type labels are visual-only text (OK). |
| **Why it matters** | Screen-reader users get less structure; once taps are wired, labels exist—good start. |
| **Severity** | **Medium** |
| **Recommended solution** | When wiring navigation, keep semantic labels; add `Semantics` on important meta; verify with TalkBack/VoiceOver. Ensure tap targets ≥ 48dp (already card-sized). |
| **Estimated time** | 2–3 hours |

#### L2. No text-scale / contrast audit

| Field | Detail |
|-------|--------|
| **Description** | Large type helps; no explicit large-text / WCAG contrast verification. Coral on cream is generally readable but unverified. |
| **Why it matters** | Moms often use larger system text sizes. |
| **Severity** | **Medium** |
| **Recommended solution** | Manual pass at 1.3×–2.0× text scale on feed/cards; adjust overflow/`maxLines` if needed. |
| **Estimated time** | 1–2 hours |

#### L3. Hardcoded English reduces a11y for target users

| Field | Detail |
|-------|--------|
| **Description** | Same as A3 from an a11y/i18n angle. |
| **Severity** | **High** (counted under A3) |
| **Recommended solution** | Localization. |
| **Estimated time** | See A3 |

---

### M. Security

#### M1. Android release signed with debug keys

| Field | Detail |
|-------|--------|
| **Description** | `android/app/build.gradle.kts` release `signingConfig` = debug. |
| **Why it matters** | Cannot ship to stores; teaches wrong release habit. |
| **Severity** | **Medium** (High before any store build) |
| **Recommended solution** | Add release keystore config via env/`key.properties` (gitignored) when preparing release. |
| **Estimated time** | 1–2 hours |

#### M2. No backend/auth — low current risk

| Field | Detail |
|-------|--------|
| **Description** | No API keys, tokens, or network stack. `.env*` gitignored. |
| **Severity** | — (strength for now) |
| **Recommended solution** | When backend arrives: secrets via `--dart-define`/secure storage; never commit keys. |
| **Estimated time** | — |

#### M3. Future location/PII caution

| Field | Detail |
|-------|--------|
| **Description** | Playdates include locations; moms + kids age ranges are sensitive socially even if mock. |
| **Why it matters** | Product will handle real PII later. |
| **Severity** | **Low** (today) |
| **Recommended solution** | Document privacy rules before real user data; minimize child-identifying fields. |
| **Estimated time** | 1 hour policy note |

---

### N. Scalability

#### N1. Structure scales; seams do not yet

| Field | Detail |
|-------|--------|
| **Description** | Folders + sealed feed + cards will carry more screens. Missing repository/router/provider will slow create/detail/backend transitions. |
| **Why it matters** | Next MVP features will force architecture catch-up under time pressure. |
| **Severity** | **High** |
| **Recommended solution** | Add thin seams **just-in-time** with Create/Detail (not a premature full clean architecture). |
| **Estimated time** | 3–6 hours (bundled with feature work) |

#### N2. Risk of over-engineering

| Field | Detail |
|-------|--------|
| **Description** | CLAUDE.md says do not over-engineer. Adding freezed/dio/auth now would violate product rules. |
| **Why it matters** | Audit must not push premature backend complexity. |
| **Severity** | **Low** (process risk) |
| **Recommended solution** | Stay mock-only until MVP screens work offline. |
| **Estimated time** | — |

---

## 4. Priority matrix (what to do next)

| Order | Item | Severity | Effort |
|------:|------|----------|--------|
| 1 | Nested navigation + Playdate/Post Detail + card `onTap` | Critical | 6–10 h |
| 2 | Create Selection + Create Playdate/Post with in-memory feed update | Critical | 8–14 h |
| 3 | Feed repository + Riverpod (or remove Riverpod) | High | 2–5 h |
| 4 | Real Profile (mock user + their cards) | High | 3–5 h |
| 5 | Korean/bilingual copy + mock refresh | High | 6–10 h |
| 6 | Docs accuracy + shell/`CardFormat` tests | Medium | 3–5 h |
| 7 | A11y text-scale pass + semantics verification | Medium | 2–3 h |
| 8 | Theme dual-path cleanup / token hygiene | Low–Medium | 1–3 h |
| 9 | Release signing when store-bound | Medium | 1–2 h |

**Suggested MVP completion effort (engineering only):** roughly **25–45 hours** of focused Flutter work from current baseline, staying mock-only.

---

## 5. CLAUDE.md compliance scorecard

| Rule / requirement | Status |
|--------------------|--------|
| Everything is a Card | **Pass** on Home; N/A elsewhere yet |
| Two card types only | **Pass** |
| Home Feed | **Pass** |
| Create Selection / Create Playdate / Create Post | **Fail** (placeholder / missing) |
| Playdate Detail / Post Detail | **Fail** |
| Profile | **Fail** (placeholder) |
| Nav: Home · Create · Profile | **Pass** (tabs exist) |
| Mock data first | **Pass** |
| No backend | **Pass** |
| Do not over-engineer | **Mostly pass** (unused Riverpod is slight over-declare) |
| Help moms connect offline | **Partial** — discover yes; create/connect loop incomplete |

---

## 6. Category scores (qualitative)

| Category | Score | Comment |
|----------|------:|---------|
| Architecture | 6/10 | Clean shape; missing seams + unused Riverpod |
| Folder structure | 9/10 | Excellent for MVP size |
| Flutter best practices | 7/10 | Strong widgets; weak routing/state adoption |
| Reusable widgets | 9/10 | Card system exemplary |
| Design system consistency | 8/10 | Strong on Home; dual-path card theme; placeholders thin |
| State management | 4/10 | Docs ≠ code; no shared feed state |
| Navigation | 4/10 | Tabs only; no stack flows |
| Naming | 8/10 | Consistent; minor generic names |
| Theme consistency | 8/10 | Tokens good; some magic numbers |
| Mock data architecture | 6/10 | Good seed; not write-capable |
| Test coverage | 7/10 | Solid for built slice; gaps for shell/format/flows |
| Performance | 9/10 | Appropriate |
| Accessibility | 5/10 | Labels started; no i18n/text-scale audit |
| Security | 8/10 | Low surface; debug release signing |
| Scalability | 6/10 | Structure yes; seams pending |
| CLAUDE.md product fit | 5/10 | Principles yes; MVP screen set incomplete |

**Overall engineering health:** **7/10 foundation**, **5/10 MVP completeness**.

---

## 7. Final recommendation

Treat the current codebase as a **successful foundation**, not a finished MVP.

**Do next (in order):**

1. Detail screens + navigation from cards  
2. Create flows that append to a shared mock feed  
3. Decide Riverpod-for-real vs remove  
4. Profile  
5. Korean language pass  

**Do not do next:**

- Supabase/auth/backend  
- Extra card types  
- Comments/photos/search/chat  
- Heavy codegen architecture  

Stay loyal to: **Everything is a Card. Simple > Complex. Mock first. Offline connections.**

---

*End of engineering audit.*
