# PROJECT_CONTEXT

Short snapshot for agents. Prefer this + `CLAUDE.md` before inventing scope.

## Version

MOMO MVP 0.1 — **Phase 3.4.8 architecture freeze** → **Phase 3.5 UI/UX validation next**

## What exists in code

- Flutter + Material 3 + design system (`core/theme`, `core/widgets`)
- Bottom nav: Home / Create / Profile
- Riverpod feature providers + mutation lifecycle
- **DI:** UI → providers → repository interfaces → impls → data sources → mock
- DTOs, `Result`, request-flow docs
- Freeze baseline: `docs/ARCHITECTURE_FREEZE.md`
- Migration checklist: `BACKEND_MIGRATION_CHECKLIST.md`

## Phase 3.5 rules (summary)

- **Allowed:** UI layout, colors, typography, components, navigation presentation, UX polish
- **Needs review:** domain models, repository interfaces, data layer, provider/DI architecture

## Hard constraints

- Mock / local only — no backend / Supabase yet
- No Business / marketplace
- No comments, photos, search, chat, notifications, payments
- Do not redesign frozen data architecture during 3.5

## Docs map

- Spec → `MVP_SPEC.md`
- Plan → `DEVELOPMENT_PLAN.md`
- Architecture → `ARCHITECTURE.md`
- **Freeze** → `docs/ARCHITECTURE_FREEZE.md`
- Backend prep → `BACKEND_MIGRATION_CHECKLIST.md`
- Agent rules → `CLAUDE.md`
