# Branch protection recommendations

These settings must be applied by a repository admin in GitHub UI
(**Settings → Branches → Add branch ruleset** / classic branch protection).
They cannot be fully enforced from the repo alone.

## `main`

Recommended ruleset:

- Require a pull request before merging
- Require approvals: **1** (CODEOWNERS)
- Require status checks to pass:
  - `CI / Analyze · Test · Build Web`
- Require branches to be up to date before merging
- Restrict who can push (no direct pushes)
- Do not allow force pushes
- Do not allow deletions
- Block merges on failure of required checks
- Require conversation resolution

Optional:

- Restrict merges to administrators for emergency only
- Require signed commits (if the team adopts GPG/SSH signing)

## `develop`

Same as `main`, except:

- Allow repository maintainers to bypass in emergencies (optional)
- Still require CI green
- Still disallow force push

## Example required check names

Exact check names come from workflow `name` + job `name`:

- Workflow: `CI`
- Job: `Analyze · Test · Build Web`

In the UI this often appears as:

`CI / Analyze · Test · Build Web`

After the first CI run on a PR, select that check under “Require status checks”.

## Environments protection

| Environment | Recommendation |
|-------------|----------------|
| `production` | Required reviewers optional; wait timer 0 for MVP |
| `preview` | No reviewers (fast integration feedback) |
| `github-pages` | Limit secrets; used by deploy jobs |

## Tags / releases

- Create GitHub Releases from `main` tags: `v0.1.0`, `v0.1.1`, …
- Prefer annotated tags after release PR merges
