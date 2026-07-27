# CI/CD Overview

MOMO uses **GitHub Actions** + **GitHub Pages** for continuous integration and deployment.

## Why these workflows exist

| Workflow | File | Why it exists |
|----------|------|----------------|
| **CI** | `ci.yml` | Gate every PR / feature push with analyze → test → web build. No deploy. Protects `develop` and `main` from red merges. |
| **PR Preview** | `pr-preview.yml` | Gives each non-draft PR a downloadable web artifact + sticky comment without overwriting production or the stable preview. |
| **Deploy Production** | `deploy-production.yml` | Only `main` ships to moms. Official `actions/deploy-pages`. Preserves `/preview/` via site assembler. |
| **Deploy Preview** | `deploy-preview.yml` | Only `develop` updates the **stable** integration preview at `/preview/`. Preserves production root via assembler. |
| **Setup Flutter** | `actions/setup-flutter` | Shared composite so every job uses the same Flutter channel, caches, and `pub get`. |

## Environments

| GitHub Environment | Branch | URL |
|--------------------|--------|-----|
| `production` | `main` (build) | https://momo.zakarbrand.com (target) |
| `preview` | `develop` (build) | https://preview.momo.zakarbrand.com (target) |
| `github-pages` | deploy job | Actual Pages deployment |

Until custom domains are attached:

- Production: https://zakarbrnd-byte.github.io/MOMO/
- Preview: https://zakarbrnd-byte.github.io/MOMO/preview/

## Repository variables (Settings → Secrets and variables → Actions → Variables)

| Variable | Default | Purpose |
|----------|---------|---------|
| `MOMO_BASE_HREF` | `/MOMO/` | Production `<base href>`. Set to `/` when custom domain is primary. |
| `MOMO_PREVIEW_BASE_HREF` | `/MOMO/preview/` | Preview `<base href>`. |
| `MOMO_PRODUCTION_URL` | github.io URL | Shown in job summaries. |
| `MOMO_PREVIEW_URL` | github.io `/preview/` | Shown in job summaries. |

## One-time setup checklist

1. **Settings → Pages → Source: GitHub Actions**
2. Create environments: `production`, `preview`, `github-pages` (Actions may auto-create `github-pages`)
3. (Recommended) Protect `main` and `develop` — see [`BRANCH_PROTECTION.md`](BRANCH_PROTECTION.md)
4. Push to `develop` then `main` once to seed both site fragments
5. Later: attach custom domain `momo.zakarbrand.com` and set `MOMO_BASE_HREF=/`

## Dual-path Pages assembler

GitHub Pages deploys **replace the entire site**. To keep production and preview stable together:

```
Site root (/)     ← production build from main
/preview/         ← develop build
```

Each deploy workflow:

1. Builds its fragment
2. Caches the fragment (`momo-production-web-*` / `momo-preview-web-*`)
3. Restores the other fragment from cache (best effort)
4. Assembles `staging/` and deploys via `upload-pages-artifact` + `deploy-pages`

## Failure notifications

- Job summaries on every workflow
- `::error` annotations on failure
- PR comments on CI / PR Preview failure
- Sticky PR preview comment updated on each push

## Related docs

- [Git Flow](GIT_FLOW.md)
- [Branch protection](BRANCH_PROTECTION.md)
- [Architecture diagrams](ARCHITECTURE_DIAGRAMS.md)
- [Future improvements](FUTURE_IMPROVEMENTS.md)
- [AI agents](../AI_AGENTS.md)
