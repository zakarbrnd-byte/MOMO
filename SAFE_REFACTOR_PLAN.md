# MOMO Safe Refactor Plan

**Source:** `ENGINEERING_AUDIT.md`  
**Date:** 2026-07-17  
**Constraint:** Planning only — **no code was modified** for this document.

## Gate (must satisfy ALL)

A task is eligible for **Safe now** only if it causes:

- No UI changes  
- No feature changes  
- No behavior changes  
- No architecture rewrite  
- No unnecessary abstraction  
- No premature optimization  

Anything that fails even one gate goes to **Later** or **Ignore until after MVP**.

Effort = implementation hours for one experienced Flutter engineer.

---

## 1. Safe now

Docs, comments, and characterization tests only. App runtime behavior must stay identical. Verify with `flutter analyze` + `flutter test` after each task.

| ID | Task | Audit refs | Why it is safe | Effort |
|----|------|------------|----------------|--------|
| S1 | **Align docs with reality** — mark screens/flows as Done / Next / Out of scope in `docs/03`, `docs/04`, `README`; note Home Feed done, Create/Profile placeholders, Details missing | A4 | Documentation only | 1–1.5 h |
| S2 | **Correct architecture docs** — update `docs/08_Architecture.md` (and README stack blurb) to say: Riverpod is declared via `ProviderScope` but unused; current state is local `setState` + static `MockFeed` | A4, B2 | Documentation only; does **not** remove/add Riverpod | 0.5 h |
| S3 | **Document card chrome ownership** — short note in `docs/06_Design_System.md` or README: feed cards use `BaseCard` + `AppCardStyle`; `ThemeData.cardTheme` is reserved/unused by feed today | C2 | Documentation only; no widget changes | 0.25–0.5 h |
| S4 | **Decide feature folder convention (docs only)** — write the ownership map for upcoming screens (e.g. `features/home`, `features/create`, `features/playdate`, `features/post`, `features/profile`) without moving files yet | B3 | Decision text only; no moves | 0.5 h |
| S5 | **Add `CardFormat` unit tests** — cover relative time buckets and playdate when-string for fixed inputs | J2, I2 | Tests only; no production code required | 0.75–1 h |
| S6 | **Add `MainShell` tab-switch widget test** — tap Create/Profile destinations; assert placeholder titles; return to Home | J2 | Tests only; asserts current behavior | 0.75–1 h |
| S7 | **Add semantics characterization tests** — when `onTap` is provided in isolation, assert existing `semanticLabel` text is present (cards already set labels) | L1, J2 | Tests only; does not change Semantics widgets | 0.5–0.75 h |

**Safe now total:** ~4–6 hours  

**Explicitly excluded from Safe now (would fail a gate):**

| Tempting item | Why not safe now |
|---------------|------------------|
| Remove unused Riverpod / `ProviderScope` | Architecture/dependency change; touches `main.dart` + tests |
| Add `FeedRepository` / providers | Architecture + abstraction |
| `MockFeed.now` → `DateTime.now()` | Behavior change (relative timestamps move) |
| Wire card `onTap` / add routes / screens | Feature + UI |
| Korean copy / `intl` | UI + product copy change |
| Rebuild `BaseCard` on Flutter `Card` | Possible visual/behavior drift |
| Promote magic numbers to tokens | Easy to mismatch values → UI drift; do only with pixel-identical values during feature work |
| Rename `Post` / `card_chrome.dart` | Churn without user value; rename risk |
| Cache `ThemeData` / optimize allocations | Premature optimization |
| Extract shared card body / `EmptyState` | Unnecessary abstraction today |
| Delete unused `AppColors.success` | Harmless but optional hygiene — defer to opportunistic Later to keep Safe now docs/tests-focused |

---

## 2. Later

Do these **with or immediately beside** real MVP feature work (Create / Detail / Profile), not as a standalone “cleanup sprint.” Prefer just-in-time seams over speculative layers.

| ID | Task | Audit refs | Gate note | Effort |
|----|------|------------|-----------|--------|
| L1 | **Adopt Riverpod for feed for real** *or* remove it when Create needs shared state — pick one; stop documenting fiction | B2, F1, I1 | Architecture change; pair with Create | 1–3 h |
| L2 | **Thin `FeedRepository` (mock impl)** when Create must append to Home | B1, I1, N1 | Abstraction only when write path exists | 2–4 h |
| L3 | **Nested navigation / router** with Detail + Create stacks | C1, G1, A1, A2 | Feature work | 3–5 h (+ screens) |
| L4 | **Detail + Create + Profile screens** (mock only) | A1, A2, C4 | Features | 12–20 h |
| L5 | **Korean / bilingual copy + mock refresh** | A3, L3 | UI/copy change | 6–10 h |
| L6 | **Validate `AppButtonStyle` on first real CTAs** | D3 | During Create forms | ~1 h |
| L7 | **Apply design tokens on new screens** as built | E1 | Part of feature work | included |
| L8 | **Optional: promote chrome magic numbers → tokens** with values kept bit-identical; screenshot/test before/after | C3 | Only if zero visual delta | 1–2 h |
| L9 | **Optional: unify `BaseCard` with `cardTheme`** only if proven identical visually | C2 | UI-risk; not docs | 1–2 h |
| L10 | **Flow tests** as each screen lands | J2 | Tests with features | 1–2 h / screen |
| L11 | **A11y text-scale manual pass**; fix only clear overflow bugs | L2 | May touch layout → treat as careful UI fix | 1–2 h |
| L12 | **Use live clock in app; keep injectable `now` for tests** | I2 | Small behavior change; do with feed work | 0.5 h |
| L13 | **Opportunistic theme hygiene** (unused `success`, button style color redundancy) when already editing theme files | E3 | Low risk if unused paths only | 0.5–1 h |

**Later bundle (with MVP features):** largely absorbed into the audit’s ~25–45 h MVP completion estimate — do not schedule as a separate refactor epic.

---

## 3. Ignore until after MVP

Do **not** schedule these before Create / Detail / Profile work green on mock data.

| ID | Task | Audit refs | Why ignore now |
|----|------|------------|----------------|
| X1 | Backend / Supabase / auth / network layer | N2, M2 | Violates mock-first; CLAUDE.md |
| X2 | `freezed` / `Equatable` / JSON serialization for models | I3 | Premature until persistence/API |
| X3 | Deep links / shareable playdate URLs | G2 | No product need yet |
| X4 | Release keystore / store signing | M1 | Only when store-bound |
| X5 | Custom Korean font packaging | E2 | Branding pass after flows work |
| X6 | Golden/snapshot tests for cards | J3 | Useful after UI freezes; flaky cost now |
| X7 | Theme allocation caching / micro-opts | K2 | Premature optimization |
| X8 | Change `IndexedStack` tab lifecycle | F2 | No pain yet |
| X9 | Extract third-card body scaffold / shared `EmptyState` / loading framework | D1, D2 | Unnecessary abstraction |
| X10 | Rename `Post` → `FeedPost` / split `card_chrome.dart` | H2, H3 | Pure churn |
| X11 | Extra card types, comments, photos, search, chat | CLAUDE.md | Explicitly out of scope |
| X12 | Privacy policy / PII hardening for real users | M3 | After real data exists |
| X13 | Full WCAG / VoiceOver certification pass | L1, L2 | After primary flows exist |

---

## Recommended sequence (safe track only)

```text
S1 Docs: Done/Next screen map          ~1–1.5 h
S2 Docs: honest Riverpod/state note    ~0.5 h
S3 Docs: BaseCard ownership note       ~0.5 h
S4 Docs: feature folder convention     ~0.5 h
S5 Tests: CardFormat                   ~1 h
S6 Tests: MainShell tabs               ~1 h
S7 Tests: semantics characterization   ~0.75 h
────────────────────────────────────────────
Safe now total                         ~4–6 h
```

Then **stop refactoring**. Resume only as part of MVP feature delivery (**Later**), not a cleanup phase.

---

## Definition of done (Safe now)

For each Safe now task:

1. Diff touches **docs and/or `test/` only** (no `lib/` behavior changes).  
2. `flutter analyze` clean.  
3. `flutter test` still green (existing + new).  
4. Manual smoke: Home feed still shows the same mixed cards and copy.

If a change requires editing production widgets/models/theme values → it is **not** Safe now; move it to Later or Ignore.

---

## Summary

| Bucket | Count | Effort | Intent |
|--------|------:|--------|--------|
| Safe now | 7 tasks | ~4–6 h | Truthful docs + characterization tests |
| Later | 13 tasks | with features | Just-in-time seams and product work |
| Ignore until after MVP | 13 items | — | Avoid over-engineering |

**Lead guidance:** The safest improvement today is **documentation honesty + tests that lock current behavior**. Do not “prepare architecture” ahead of Create/Detail. That matches CLAUDE.md: *Simple > Complex. Do not over-engineer.*
