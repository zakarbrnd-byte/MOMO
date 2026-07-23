# DevOps changelog — Git Flow & CI/CD

## 2026-07-23 — Production-grade Git workflow

### Added

- Git Flow documentation (`docs/cicd/GIT_FLOW.md`)
- CI workflow for PRs / feature branches (`.github/workflows/ci.yml`)
- Production deploy on `main` (`.github/workflows/deploy-production.yml`)
- Preview deploy on `develop` (`.github/workflows/deploy-preview.yml`)
- PR preview artifacts + sticky comments (`.github/workflows/pr-preview.yml`)
- Shared Flutter setup composite action
- Issue templates, PR template, CODEOWNERS, CONTRIBUTING
- AI agent parallel-work guide (`docs/AI_AGENTS.md`)
- Architecture / branch / pipeline diagrams
- Future improvements list
- Branch protection recommendations
- `.env.example`, hardened `.gitignore`, VS Code extension recommendations

### Changed

- Replaced single `flutter-web.yml` with environment-aware pipeline suite
- README badges + Web Deployment section for prod + preview

### Why

Multiple AI agents and humans need a safe integration branch, protected production, deterministic quality gates, and stable preview URLs without manual deploys.
