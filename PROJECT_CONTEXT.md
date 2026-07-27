# PROJECT_CONTEXT

Short snapshot for agents. Prefer this + `CLAUDE.md` before inventing scope.

## Version

MOMO MVP 0.1 — **Phase 3.5 UI redesign** (playdate-first Korean mom community) on top of Phase 3.4.8 architecture freeze

## What exists in code

- Flutter + Material 3 + design system (`core/theme`, `core/widgets`)
- Bottom nav: 홈 / 만들기 / 프로필
- Home: hero CTA, filters, upcoming playdates, popular/recent posts, category chips, redesigned cards
- Engagement metrics display-only (`viewCount` / `commentCount` / `likeCount`)
- Riverpod feature providers + mutation lifecycle + home filter/section providers
- **DI:** UI → providers → repository interfaces → impls → data sources → mock
- DTOs, `Result`, request-flow docs
- Freeze baseline: `docs/ARCHITECTURE_FREEZE.md`
- Migration checklist: `BACKEND_MIGRATION_CHECKLIST.md`
- Status: `docs/CURRENT_STATUS.md`

## Phase 3.5 rules (summary)

- **Allowed:** UI layout, colors, typography, components, navigation presentation, UX polish, mock content expansion
- **Reviewed exception used:** denormalized engagement + post category/author display fields on domain models/DTOs (display-only)
- **Needs review:** further domain model structure, repository contracts, data-source contracts, provider/DI ownership changes

## Hard constraints

- Mock / local only — no backend / Supabase yet
- No Business / marketplace
- No interactive comments/likes/views, photos, search, chat, notifications, payments
- Do not replace Riverpod or bypass repositories

## Docs map

- Spec → `MVP_SPEC.md`
- Plan → `DEVELOPMENT_PLAN.md`
- Architecture → `ARCHITECTURE.md`
- **Freeze** → `docs/ARCHITECTURE_FREEZE.md`
- Backend prep → `BACKEND_MIGRATION_CHECKLIST.md`
- Agent rules → `CLAUDE.md`
- Design → `docs/06_Design_System.md`
- Status → `docs/CURRENT_STATUS.md`
