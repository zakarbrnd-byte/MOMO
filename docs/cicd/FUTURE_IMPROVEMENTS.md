# Future improvements

Prioritized upgrades after the current Git Flow + Pages foundation.

## High value

1. **Ephemeral hosted PR previews**  
   Publish each PR to Cloudflare Pages / Netlify / Firebase Hosting with a unique URL and auto-comment. Keeps GitHub Pages dual-path assembler only for `main` + `develop`.

2. **Custom domains**  
   - `momo.zakarbrand.com` → production  
   - `preview.momo.zakarbrand.com` → preview (separate project or path rewrite)  
   Set `MOMO_BASE_HREF=/` when production is served at domain root.

3. **Required status checks via rulesets-as-code**  
   Manage branch protection with the GitHub Rulesets API / Terraform once org permissions allow.

4. **Matrix CI**  
   Run analyze/tests on a pinned Flutter version file (`.fvmrc` or `flutter-version`) for reproducibility across agents.

5. **Golden / integration tests on web**  
   Add a small set of smoke tests that run headless against the built web bundle.

## Medium value

6. **Slack / Discord failure webhooks** for production deploy failures  
7. **Dependabot** for GitHub Actions + pub packages  
8. **Code coverage** upload (codecov or similar) with a soft threshold  
9. **Release workflow** that creates GitHub Releases + changelog from conventional commits  
10. **Separate preview hosting** so develop deploys never re-upload production bytes

## Lower priority / later phases

11. Android / iOS CD (Fastlane + Play / TestFlight)  
12. Environment-flavored builds (dev/stage/prod Dart defines)  
13. OIDC deploy to Supabase / cloud backends (Phase 4)  
14. SBOM + dependency scanning on every PR  
15. Playwright visual regression against `/` and `/preview/`

## Explicit non-goals (MVP)

- Chat, payments, business accounts
- Replacing mock data with production backend before Phase 4
- Multiple GitHub Pages sites in one repo without an assembler or external host
