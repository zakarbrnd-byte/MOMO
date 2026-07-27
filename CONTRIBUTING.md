# Contributing to MOMO

Thank you for helping build MOMO — a Flutter app for Korean mothers in the US to discover and create playdates.

This repository is developed by **humans and multiple AI coding agents in parallel**. Follow this guide so merges stay safe and deploys stay green.

## Quick start

```bash
git clone https://github.com/zakarbrnd-byte/MOMO.git
cd MOMO
git checkout develop
flutter pub get
flutter run
```

## Branch model (Git Flow)

| Branch | Purpose | Deploys |
|--------|---------|---------|
| `main` | Production | Production GitHub Pages |
| `develop` | Integration | Stable preview (`/preview/`) |
| `feature/*` | New work (humans + AI agents) | CI only |
| `release/*` | Release hardening | CI only |
| `hotfix/*` | Emergency production fixes | CI; merge to `main` + `develop` |

Full details: [`docs/cicd/GIT_FLOW.md`](docs/cicd/GIT_FLOW.md)

### Branch naming

```
feature/<short-topic>          # preferred for humans + agents
feature/<agent>-<topic>        # when multiple agents need isolation
release/x.y.z
hotfix/<short-topic>
```

Legacy Cursor cloud branches (`cursor/<topic>-8280`) are allowed during transition; open PRs into `develop`, not `main`.

## Commit messages (Conventional Commits)

```
feat: add playdate capacity banner
fix: prevent double-join on slow networks
ci: cache pub dependencies in deploy preview
docs: explain Git Flow for AI agents
chore: tighten gitignore for IDE files
hotfix: restore home feed empty state
```

Scope optional: `feat(home): ...`, `fix(ci): ...`.

## Pull requests

1. Branch from `develop` (or `main` only for hotfixes).
2. Keep PRs small and folder-scoped ([`docs/AI_AGENTS.md`](docs/AI_AGENTS.md)).
3. Ensure CI is green (`analyze`, `test`, `build web`).
4. Fill out the PR template.
5. Merge with **squash** into `develop` (recommended) to keep history readable.

Do **not** push directly to `main` or `develop` once branch protection is enabled.

## Quality bar

Before you push / open a PR:

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
flutter build web --release
```

## Architecture freeze

Phases through 3.4 are frozen. UI/UX validation must not silently change architecture.
See [`docs/ARCHITECTURE_FREEZE.md`](docs/ARCHITECTURE_FREEZE.md).

## Deployments

| Environment | URL (until custom DNS) | Trigger |
|-------------|------------------------|---------|
| Production | https://zakarbrnd-byte.github.io/MOMO/ | Push to `main` |
| Preview | https://zakarbrnd-byte.github.io/MOMO/preview/ | Push to `develop` |
| Custom (target) | https://momo.zakarbrand.com | DNS + Pages custom domain |
| Preview custom (target) | https://preview.momo.zakarbrand.com | Future path / DNS |

Details: [`docs/cicd/README.md`](docs/cicd/README.md)

## Code owners

Reviews are requested via [`.github/CODEOWNERS`](.github/CODEOWNERS).

## Security

- Never commit `.env`, tokens, keystores, or service accounts.
- Use GitHub Secrets / Variables for CI configuration (`MOMO_BASE_HREF`, etc.).
- Report security issues privately to the repository owner.
