# Safe Now Refactor Summary

**Source plan:** `SAFE_REFACTOR_PLAN.md` § Safe now (S1–S7)  
**Date:** 2026-07-17  
**Scope:** Docs + characterization tests only  
**`lib/` production code:** unchanged  

## Verification

| Check | Result |
|-------|--------|
| `flutter analyze lib test` | No issues |
| `flutter test` | **25/25 passed** (was 14) |
| UI / features / behavior | Identical (no `lib/` edits) |
| New packages / Riverpod providers / Repository | None |

---

## Files changed

### Documentation (S1–S4)

| File | Why | Before | After | Risk |
|------|-----|--------|-------|------|
| `docs/03_MVP_Features.md` | Align feature list with reality | Screens listed as if all exist | Done / Next / Placeholder / Out of scope tables | **Low** |
| `docs/04_User_Flow.md` | Align flows with reality | Browse/Create/Profile as complete paths | Each step marked Done / Next / Placeholder | **Low** |
| `docs/08_Architecture.md` | Stop claiming unused Riverpod architecture | “Flutter / Riverpod / Mock data” | Honest note: `ProviderScope` present, no providers; `setState` + `MockFeed` | **Low** |
| `docs/06_Design_System.md` | Document card chrome ownership | Four adjectives only | Tokens table + `BaseCard`/`AppCardStyle` as feed chrome source of truth; `cardTheme` unused by feed | **Low** |
| `README.md` | Status, stack honesty, feature folder convention | Implied Riverpod-in-use; no status | Stack caveat, status table, upcoming folder map (no file moves) | **Low** |

### Tests (S5–S7)

| File | Why | Before | After | Risk |
|------|-----|--------|-------|------|
| `test/card_format_test.dart` | **New** — lock `CardFormat` buckets | — | Unit tests for playdate when-string + relative post time | **Low** |
| `test/main_shell_test.dart` | **New** — lock tab switching / IndexedStack | — | Tap Home→Create→Profile→Home; offstage children with `skipOffstage: false` | **Low** |
| `test/card_semantics_test.dart` | **New** — characterize existing `BaseCard` semantics | — | Label prefix + `isButton` with/without `onTap` (merged descendant text accounted for) | **Low** |

### Not changed (intentionally)

- All of `lib/`
- `pubspec.yaml` / packages
- Platform folders
- Widget visuals, mock data, navigation behavior

---

## Task checklist

| ID | Task | Status |
|----|------|--------|
| S1 | Align docs with Done/Next reality | Done |
| S2 | Correct architecture / Riverpod docs | Done |
| S3 | Document `BaseCard` chrome ownership | Done |
| S4 | Feature folder convention (docs only) | Done |
| S5 | `CardFormat` unit tests | Done |
| S6 | `MainShell` tab-switch tests | Done |
| S7 | Semantics characterization tests | Done |

---

## Risk summary

| Level | Items |
|-------|--------|
| **Low** | All changes — docs truth + tests that assert current behavior |
| **Medium / High** | None |

No production code paths were rewritten. Failures during test authoring were fixed in **tests only** (semantics merge + offstage finders), not by changing widgets.

---

## Explicitly not done (per Safe now exclusions)

- Remove Riverpod / `ProviderScope`
- Add providers or Repository
- Wire card `onTap` / routes / new screens
- Rename types, extract widgets, promote magic numbers
- Change `MockFeed.now` behavior
- Any UI or feature work
