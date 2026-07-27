# MOMO

Community app for Korean mothers in the US.

**MVP goal:** Help moms discover and create local playdates, and share parenting-related posts.

Version: **MVP 0.1** · Status: **Phase 3.4 complete (architecture freeze)** → next **Phase 3.5 UI/UX validation**

[![CI](https://github.com/zakarbrnd-byte/MOMO/actions/workflows/ci.yml/badge.svg)](https://github.com/zakarbrnd-byte/MOMO/actions/workflows/ci.yml)
[![Deploy Production](https://github.com/zakarbrnd-byte/MOMO/actions/workflows/deploy-production.yml/badge.svg)](https://github.com/zakarbrnd-byte/MOMO/actions/workflows/deploy-production.yml)
[![Deploy Preview](https://github.com/zakarbrnd-byte/MOMO/actions/workflows/deploy-preview.yml/badge.svg)](https://github.com/zakarbrnd-byte/MOMO/actions/workflows/deploy-preview.yml)

## Current features

| Area | Status |
|------|--------|
| Flutter app shell + Material 3 + design system | Done |
| Bottom nav: Home · Create · Profile | Done |
| Home feed (Playdate + Post) via Riverpod | Done |
| Detail screens + Join / Leave / Cancel | Done |
| Create Playdate / Post → feed (local) | Done |
| Profile via providers (mock data source) | Done |
| Repository + data source + DI layer | Done |
| Git Flow + CI/CD (Pages production & preview) | Done |
| Backend / auth / Supabase | Not started |

## Tech stack

- **Framework:** Flutter
- **State:** Riverpod (feature providers + DI)
- **UI:** Material 3 + shared `core/widgets`
- **Data:** Mock data sources only (swap-ready for Supabase)
- **CI/CD:** GitHub Actions → GitHub Pages

## Project structure (simplified)

```
lib/
  main.dart                 # ProviderScope
  providers/                # Feature state
  repositories/             # Interfaces + impls + DI
  data/datasources/         # Interfaces + mock impls + DI
  dto/                      # JSON ⇄ domain
  models/                   # Domain
  features/                 # UI only
  core/                     # Theme, widgets, async, result
.github/workflows/          # CI + deploy pipelines
docs/cicd/                  # Git Flow + pipeline docs
```

## Run

```bash
flutter pub get
flutter run
```

**Windows note:** The project path must not contain `#`. Prefer a junction without `#`, e.g. `C:\Users\Tim\Projects\ZAKAR-MOMO`.

## Contributing & Git Flow

- Read **[CONTRIBUTING.md](CONTRIBUTING.md)** before opening a PR
- Default integration branch: **`develop`**
- Production branch: **`main`**
- AI agents: **[docs/AI_AGENTS.md](docs/AI_AGENTS.md)**
- Full Git Flow: **[docs/cicd/GIT_FLOW.md](docs/cicd/GIT_FLOW.md)**

```text
feature/* ──PR──► develop ──release──► main
                     │                   │
                     ▼                   ▼
                 /preview/            production /
```

## Documentation

| File | Purpose |
|------|---------|
| [MVP_SPEC.md](MVP_SPEC.md) | Scope in / out |
| [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) | Phases |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Live architecture detail |
| [docs/ARCHITECTURE_FREEZE.md](docs/ARCHITECTURE_FREEZE.md) | **Frozen baseline (3.4.8)** |
| [BACKEND_MIGRATION_CHECKLIST.md](BACKEND_MIGRATION_CHECKLIST.md) | Pre-Supabase checklist |
| [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) | Short snapshot |
| [CLAUDE.md](CLAUDE.md) | Agent rules |
| [docs/cicd/README.md](docs/cicd/README.md) | CI/CD overview |
| [docs/cicd/ARCHITECTURE_DIAGRAMS.md](docs/cicd/ARCHITECTURE_DIAGRAMS.md) | Architecture / branch / pipeline diagrams |
| [docs/cicd/FUTURE_IMPROVEMENTS.md](docs/cicd/FUTURE_IMPROVEMENTS.md) | Roadmap for DevOps upgrades |

## Development status

- **Completed:** Phases 1–3.4 — foundation, local state, design system, repositories, DTOs, DI, migration readiness, **architecture freeze**, **Git Flow + automated web deploys**
- **Next:** Phase 3.5 — UI/UX validation (layout/visual/UX only; respect freeze rules)
- **Future:** Phase 4 — auth, Supabase, real persistence

# Web Deployment

## URLs

| Environment | URL |
|-------------|-----|
| **Production** (from `main`) | https://zakarbrnd-byte.github.io/MOMO/ |
| **Preview** (from `develop`) | https://zakarbrnd-byte.github.io/MOMO/preview/ |
| **Production custom (target)** | https://momo.zakarbrand.com |
| **Preview custom (target)** | https://preview.momo.zakarbrand.com |

## How deployment works

1. **Pull requests** → [`ci.yml`](.github/workflows/ci.yml) runs analyze / test / build (no deploy). [`pr-preview.yml`](.github/workflows/pr-preview.yml) uploads a web artifact and comments on the PR.
2. **Push to `develop`** → [`deploy-preview.yml`](.github/workflows/deploy-preview.yml) builds Flutter Web and deploys the **stable preview** at `/preview/`.
3. **Push to `main`** → [`deploy-production.yml`](.github/workflows/deploy-production.yml) builds Flutter Web and deploys **production** at site root.
4. Both deploy workflows use official `actions/upload-pages-artifact` + `actions/deploy-pages`, with a dual-path assembler so production and preview do not wipe each other.

**One-time setup:** Repo **Settings → Pages → Build and deployment → Source: GitHub Actions**. Apply branch protection from [`docs/cicd/BRANCH_PROTECTION.md`](docs/cicd/BRANCH_PROTECTION.md).

## Force redeploy

- **Production:** Actions → **Deploy Production** → **Run workflow**
- **Preview:** Actions → **Deploy Preview** → **Run workflow**
- Or empty commit on the target branch: `git commit --allow-empty -m "chore: redeploy" && git push`

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Deploy job cannot write Pages | Enable Pages source = **GitHub Actions**; approve `github-pages` environment if required |
| Blank page / missing assets | Confirm `MOMO_BASE_HREF` (default `/MOMO/`) and hard-refresh |
| Preview missing after production deploy | Push `develop` once to refresh the preview fragment cache, then redeploy production if needed |
| PR checks red | Run `flutter analyze --fatal-infos && flutter test && flutter build web --release` locally |
| Custom domain not working | Attach domain in Pages settings; set `MOMO_BASE_HREF=/`; wait for DNS |
