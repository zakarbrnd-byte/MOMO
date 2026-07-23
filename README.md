# MOMO

Community app for Korean mothers in the US.

**MVP goal:** Help moms discover and create local playdates, and share parenting-related posts.

Version: **MVP 0.1** · Status: **Phase 3.4 complete (architecture freeze)** → next **Phase 3.5 UI/UX validation**

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
| Backend / auth / Supabase | Not started |

## Tech stack

- **Framework:** Flutter
- **State:** Riverpod (feature providers + DI)
- **UI:** Material 3 + shared `core/widgets`
- **Data:** Mock data sources only (swap-ready for Supabase)

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
```

## Run

```bash
flutter pub get
flutter run
```

**Windows note:** The project path must not contain `#`. Prefer a junction without `#`, e.g. `C:\Users\Tim\Projects\ZAKAR-MOMO`.

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

## Development status

- **Completed:** Phases 1–3.4 — foundation, local state, design system, repositories, DTOs, DI, migration readiness, **architecture freeze**
- **Next:** Phase 3.5 — UI/UX validation (layout/visual/UX only; respect freeze rules)
- **Future:** Phase 4 — auth, Supabase, real persistence

# Web Deployment

**URL:** https://zakarbrnd-byte.github.io/MOMO/

## How deployment works

1. Push (or merge) to `main`.
2. GitHub Actions runs [`.github/workflows/flutter-web.yml`](.github/workflows/flutter-web.yml):
   - Installs Flutter **stable** (cached)
   - `flutter pub get` → `flutter analyze` → `flutter test`
   - `flutter build web --release` with the correct `--base-href` for this repo
   - Uploads `build/web` via `actions/upload-pages-artifact`
   - Deploys with official `actions/deploy-pages`
3. The site updates on GitHub Pages (usually within a minute after a green run).

**One-time setup:** Repo **Settings → Pages → Build and deployment → Source: GitHub Actions**. After that, deploys are automatic.

## Force redeploy

- GitHub → **Actions** → **Flutter Web → GitHub Pages** → **Run workflow** (`workflow_dispatch`), or
- Push an empty commit to `main`: `git commit --allow-empty -m "chore: redeploy web" && git push`

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Actions fails at “Deploy to GitHub Pages” | Enable Pages source = **GitHub Actions** (see one-time setup). Approve the `github-pages` environment if required. |
| Blank page / missing JS & assets | Confirm `--base-href` is `/MOMO/` (workflow uses `actions/configure-pages`). Hard-refresh the browser. |
| 404 on refresh of a deep path | Workflow copies `index.html` → `404.html` and adds `.nojekyll`. Re-run the workflow if those steps were skipped. |
| Analyze / tests fail the deploy | Fix locally with `flutter analyze` and `flutter test`, then push again. |
| Stale site after a green deploy | Wait for the Pages deployment to finish; check the workflow’s **deploy** job URL output. |
