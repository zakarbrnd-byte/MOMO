# MOMO Project Review

**Date:** 2026-07-17  
**Scope:** Full codebase (`lib/`, `test/`, platforms, docs, config)  
**Version:** MVP 0.1  
**Constraint:** Analysis only — no code was modified for this review.

---

## Executive summary

MOMO is a clean, intentionally small Flutter MVP. The strongest work is the design system and the “Everything is a Card” feed (Home + shared card widgets). The main gaps are unfinished MVP screens, Riverpod declared but unused, English/SoCal copy for a Korean-moms product, and no routing beyond bottom tabs.

Approx. size: ~22 Dart files in `lib/` (~1.3k LOC) · 4 test files · 14 tests passing.

---

## Current structure

```text
lib/
  main.dart / app.dart
  core/theme/          # colors, type, spacing, card, button, AppTheme
  data/models/         # MomUser, Playdate, Post, FeedItem
  data/mock/           # MockFeed
  features/
    home/              # HomeFeedScreen (real)
    create/            # placeholder
    profile/           # placeholder
  navigation/          # MainShell (Home · Create · Profile)
  shared/widgets/cards/# BaseCard, PlaydateCard, PostCard, chrome
test/                  # design system, cards, home feed, smoke
android/ ios/ web/     # platform scaffolds present
docs/                  # product + architecture notes
```

---

## 1. Strengths

| Area | Notes | Priority |
|------|-------|----------|
| Folder structure | Clear feature / data / shared / core split; easy to navigate for an MVP | — |
| Design system | Central tokens (`AppColors`, `AppTypography`, `AppSpacing`, `AppCardStyle`, `AppButtonStyle`) wired through `AppTheme` | — |
| Card reuse | `BaseCard` + shared chrome (`CardTypeLabel`, `CardMetaRow`, `CardAuthorRow`) keep Playdate/Post visually consistent | — |
| Product principle | Home feed truly follows “Everything is a Card” with two card types only | — |
| Models | Immutable DTOs; sealed `FeedItem` gives exhaustive UI branching | — |
| Mock-first discipline | No backend/auth/network packages; matches CLAUDE.md rules | — |
| Testability | Injectable `items` / `now` on feed and post cards; good widget tests for cards + feed | — |
| Lint baseline | `prefer_const_*` + `avoid_print`; analyze clean; tests green | — |
| Platforms | `android/`, `ios/`, `web/` regenerated; `lib/` preserved | — |
| Security surface | Minimal — no secrets in source, `.env` gitignored, no network/auth yet | — |

---

## 2. Problems

### High

| ID | Problem | Why it matters |
|----|---------|----------------|
| H1 | **MVP screens incomplete** — Create Selection, Create Playdate/Post, Playdate Detail, Post Detail are documented but missing; Create/Profile are placeholders | App cannot complete documented user flows |
| H2 | **No detail navigation** — cards accept `onTap` but Home does not push detail routes; no `Navigator` / router setup | Feed is browse-only; “discover → connect” loop is broken |
| H3 | **Riverpod unused** — `ProviderScope` wraps the app, but there are zero providers / `ConsumerWidget`s; docs claim Riverpod architecture | Architecture docs and code diverge; dependency is dead weight |
| H4 | **UI tightly coupled to `MockFeed`** — Home reads static mock data directly with no repository/provider seam | Harder to swap mock → real data later without rewriting screens |

### Medium

| ID | Problem | Why it matters |
|----|---------|----------------|
| M1 | **Locale mismatch** — product is for Korean mothers; UI copy, dates (`CardFormat`), and mock content are English + SoCal | Weak product fit; initials helper is Western-name-centric |
| M2 | **Theme not fully applied** — `BaseCard` uses raw `Material` + `AppCardStyle`, bypassing `ThemeData.cardTheme`; some chrome sizes are magic numbers | Design system is partially dual-path |
| M3 | **Placeholder duplication** — Create and Profile screens are near-identical scaffolds | Noise when real features land |
| M4 | **Docs overstate shipping state** — flows/features listed as if present | Misleads contributors on what’s done |
| M5 | **Android release uses debug signing** | Fine for local MVP; not shippable |
| M6 | **Test gaps** — no tab-shell tests, no `CardFormat` unit tests, no golden/a11y checks | Regressions possible as features grow |

### Low

| ID | Problem | Why it matters |
|----|---------|----------------|
| L1 | Generic type name `Post` may collide as domain grows | Naming clarity |
| L2 | `IndexedStack` keeps all tabs alive | OK at 3 light tabs; revisit if Create/Profile get heavy |
| L3 | No dark theme / custom fonts / i18n package | Acceptable for MVP; plan ahead for Korean typography |
| L4 | Models lack `==` / `copyWith` / serialization | Only needed when state/backend arrives |
| L5 | `success` color unused; some button style color redundancy | Minor token hygiene |

---

## 3. Suggested improvements

### High priority

| Improvement | Addresses | Guidance |
|-------------|-----------|----------|
| Implement remaining MVP screens (Create Selection → Create Playdate/Post; Playdate/Post Detail; Profile shell) | H1 | Stay mock-only; keep card language |
| Wire card taps to detail screens via a simple router (`go_router` or named routes) | H2 | One navigation map for feed → detail → back |
| Introduce Riverpod providers for feed (and later create/profile), or remove Riverpod until needed | H3 | Prefer a thin `feedProvider` reading a repository interface |
| Add `FeedRepository` (mock impl now) so UI does not import `MockFeed` | H4 | Keeps CLAUDE.md mock-first rule while enabling swap later |

### Medium priority

| Improvement | Addresses | Guidance |
|-------------|-----------|----------|
| Add Korean-first copy + `intl` / `flutter_localizations` (or bilingual EN/KO) | M1 | Localize `CardFormat` and screen strings |
| Drive cards from themed `Card` or ensure `BaseCard` is the single source of card chrome | M2 | Eliminate duplicate radius/border definitions |
| Replace placeholders with real Create/Profile scaffolds when building those features | M3 | Avoid shared empty placeholder abstraction — just build the screens |
| Align docs (`03`, `04`, `08`, README) with implemented vs planned | M4 | Mark “Done / Next” explicitly |
| Add release signing config when preparing store builds | M5 | Keep debug signing for local only |
| Extend tests: tab switching, `CardFormat` edge cases, semantics labels on cards | M6 | Keep tests lightweight |

### Low priority

| Improvement | Addresses | Guidance |
|-------------|-----------|----------|
| Consider renaming `Post` → `MomPost` / `FeedPost` if ambiguity appears | L1 | Only if collisions hurt |
| Lazy-load heavy tabs if Create becomes form-heavy | L2 | Measure before changing |
| Pick a Korean-friendly font when branding hardens | L3 | Keep warm/minimal look |
| Add `Equatable`/`freezed` only when copyWith/JSON become real needs | L4 | Do not over-engineer now |
| Prune unused tokens / simplify button style color wiring | L5 | Opportunistic cleanup |

---

## 4. Analysis by category

### Folder structure

**Good.** Feature-first layout with `core`, `data`, `features`, `navigation`, `shared` is appropriate for MVP and scales to more screens without a rewrite.

**Watch:** As Create/Detail grow, keep feature folders self-contained (`features/playdate/`, `features/post/`) rather than dumping everything under `home/`.

### Flutter best practices

**Good:** `const` usage, sealed unions, Material 3 theme, `CustomScrollView` + `SliverList`, stable `ValueKey`s, semantic labels on cards.

**Gaps:** No routing layer; Riverpod scaffold without providers; screen ↔ mock coupling; incomplete MVP vs CLAUDE.md.

### Code quality

**Good:** Small files, readable composition, little dead code, analyze clean.

**Gaps:** Magic numbers in chrome/theme; English hardcoded strings; placeholder duplication; docs/code drift.

### Reusable widgets

**Good:** Card system is the reuse centerpiece and matches the product principle.

**Gaps:** Theme button styles unused in UI so far; no shared empty/loading components yet (only home empty state); placeholders don’t reuse design system much.

### Naming consistency

**Good:** snake_case files, PascalCase types, consistent Playdate/Post/MomUser vocabulary.

**Gaps:** `Post` is generic; `card_chrome.dart` is a grab-bag name; product language (Korean moms) vs content language (EN/SoCal).

### State management

**Current:** Local `setState` for tab index; static mock data; constructor injection for tests.

**Issue:** Riverpod is declared in `pubspec` / docs / `ProviderScope` but unused.

**Recommendation:** Either adopt providers for feed (High) or drop the dependency until create/auth need shared state (also valid under “do not over-engineer”).

### Performance

**Fine for MVP.** Short mock list, no images/network, const-friendly widgets. `IndexedStack` cost is negligible today. No urgent performance work.

### Security

**Low risk now** — no backend, auth, storage of secrets, or dangerous permissions.

**Before shipping:** replace Android debug signing; keep `.env` / keystores out of git; review permissions when location/photos are added (explicitly out of scope today).

### Scalability

**Structure scales; architecture seams do not yet.** Sealed feed items and card widgets will carry more screens well. Missing repository/router/provider layers will slow the jump from mock feed → create/detail → eventual backend. Add those seams just-in-time as features land — don’t build a full backend stack early.

---

## 5. Priority roadmap (suggested order)

1. **High** — Detail screens + navigation from cards  
2. **High** — Create Selection / Create Playdate / Create Post (mock write into feed)  
3. **High** — Decide: real Riverpod feed layer *or* remove unused Riverpod  
4. **Medium** — Profile screen (mock user + their cards)  
5. **Medium** — Localization / Korean copy pass  
6. **Medium** — Doc accuracy + targeted test gaps  
7. **Low** — Token/naming polish, release signing when needed  

---

## 6. Verdict

MOMO’s foundation is solid: warm design system, coherent card language, clean folder layout, and a working mock Home Feed. It is not yet a complete MVP per CLAUDE.md (create + detail + profile flows missing), and architecture docs ahead of the code (Riverpod). Fix navigation and remaining screens next; keep mock-first and avoid over-engineering.
