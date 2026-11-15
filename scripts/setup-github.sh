#!/usr/bin/env bash
# Prepares the Sudoo-sh GitHub organization: creates (or updates) every repository with its description, website,
# topics and settings, applies the branch rules, turns on security alerts, adds the shared labels, makes the first
# commit of each local folder and pushes it.
#
# Run it from anywhere, with the GitHub CLI signed in as an owner of the organization:
#   gh auth login                      # once; the token needs the "repo" scope
#   ~/sudoo-github/scripts/setup-github.sh            # everything
#   ~/sudoo-github/scripts/setup-github.sh --dry-run  # only print what it would do
#   ~/sudoo-github/scripts/setup-github.sh sudoo-hub  # only the named repositories
#
# Safe to run again: existing repositories are updated, never deleted; nothing is force-pushed unless a remote
# repository holds only GitHub's own "Initial commit" and REPLACE_INITIAL=1 is set.
#
# Branch rules on private repositories need a paid plan (GitHub Team) on organization accounts; on the free plan the
# script reports this and carries on. The public repositories get them either way.

set -euo pipefail

ORG="${ORG:-Sudoo-sh}"
ROOT="${ROOT:-$HOME}"
DRY_RUN=0
ONLY=()
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h | --help) sed -n '2,16p' "$0"; exit 0 ;;
    *) ONLY+=("$arg") ;;
  esac
done

# name | local folder | visibility | website | description | topics (comma-separated)
REPOS=(
  ".github|sudoo-github|public|https://sudoo.sh|Profile and shared community files of the Sudoo.sh organization.|sudoo,organization,community"
  "sudoo-website|sudoo-website|private|https://sudoo.sh|The sudoo.sh website: product, features, pricing, plugins, legal. Astro, static, strict CSP.|sudoo,odoo,website,astro,static-site,seo"
  "sudoo-docs|sudoo-docs|private|https://docs.sudoo.sh|docs.sudoo.sh: the Sudoo.sh documentation, built from the panel's docs with VitePress.|sudoo,odoo,documentation,vitepress"
  "sudoo-marketplace|sudoo-marketplace|private|https://marketplace.sudoo.sh|marketplace.sudoo.sh: the catalogue of signed plugins for Sudoo.sh. Next.js.|sudoo,odoo,marketplace,plugins,nextjs"
  "sudoo-developers|sudoo-developers|private|https://developers.sudoo.sh|developers.sudoo.sh: publish plugins, follow analytics and payouts. Next.js.|sudoo,odoo,developer-portal,plugins,nextjs"
  "sudoo-account|sudoo-account|private|https://app.sudoo.sh|app.sudoo.sh: servers, licences, plugins, billing and team of a Sudoo.sh account. Next.js.|sudoo,odoo,dashboard,billing,nextjs"
  "sudoo-admin|sudoo-admin|private|https://admin.sudoo.sh|admin.sudoo.sh: the staff console: review desk and rules, dashboards, support, finance, staff. Next.js.|sudoo,admin,dashboard,review,nextjs"
  "sudoo-hub|sudoo-hub|private|https://hub.sudoo.sh|hub.sudoo.sh: accounts, panel registration and heartbeats, licences, signed plugin catalogue. FastAPI.|sudoo,odoo,fastapi,postgresql,redis,ed25519,licensing"
  "sudoo-cluster|sudoo-cluster|private||Docker Compose, Nginx and Certbot stack that hosts every *.sudoo.sh property on one server.|sudoo,docker-compose,nginx,certbot,infrastructure"
  "sudoo-status|sudoo-status|private|https://status.sudoo.sh|status.sudoo.sh: uptime and certificate checks of every Sudoo.sh property, with Gatus.|sudoo,status-page,gatus,monitoring"
  "sudoo-plugin-sdk|sudoo-plugin-sdk|public|https://docs.sudoo.sh|SDK and CLI for building Sudoo.sh plugins: manifest types, base classes, test harness, packing.|sudoo,plugins,sdk,python"
  "sudoo-plugin-template|sudoo-plugin-template|public|https://developers.sudoo.sh|Start a Sudoo.sh plugin: a working example, CI, and a release workflow for the marketplace.|sudoo,plugins,template"
  "sudoo-installer|sudoo-installer|private||Private: the Sudoo.sh installer (sudoo-install.sh), its tests, and the script that checks and attaches it to each release.|sudoo,installer,bash"
  "sudoo-plugins|sudoo-plugins|private|https://marketplace.sudoo.sh|The official Sudoo.sh plugins (mailer, second factors, tunnels, API, MCP, themes), one folder each.|sudoo,odoo,plugins"
)

# shared labels: name|colour|description
LABELS=(
  "feature|714B67|New behaviour"
  "fix|DC2626|Something does not work as documented"
  "security|B45309|Security issue or hardening"
  "docs|0F766E|Documentation only"
  "design|C79BBD|Look, motion, accessibility"
  "performance|2563EB|Speed, size, Core Web Vitals"
  "dependencies|737373|Dependency updates"
  "ci|525252|Workflows and tooling"
  "blocked|171717|Waiting for something else"
)

# Teams: the owner is the only organization admin; developers get write access to their own repositories only.
# team|description|repositories (comma-separated)
TEAMS=(
  "core-devs|Developers of the panel, the hub and the infrastructure|sudoo.sh,sudoo-hub,sudoo-cluster,sudoo-status,sudoo-installer"
  "web-devs|Developers of the websites and web apps|sudoo-website,sudoo-docs,sudoo-marketplace,sudoo-developers,sudoo-account,sudoo-admin"
  "plugin-devs|Developers of the plugin SDK, the template and the official plugins|sudoo-plugin-sdk,sudoo-plugin-template,sudoo-plugins"
)

say() { printf '\033[1m%s\033[0m %s\n' "$1" "${2:-}"; }
warn() { printf '\033[33mwarning:\033[0m %s\n' "$*" >&2; }
run() { if ((DRY_RUN)); then printf '  would run: %s\n' "$*"; else "$@"; fi; }
api() { if ((DRY_RUN)); then printf '  would call: gh api %s\n' "$*"; else gh api "$@" >/dev/null; fi; }

wanted() {
  ((${#ONLY[@]} == 0)) && return 0
  local name
  for name in "${ONLY[@]}"; do [[ "$name" == "$1" || "$name" == "$2" ]] && return 0; done
  return 1
}

command -v gh >/dev/null || { echo "Install the GitHub CLI first: https://cli.github.com"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Sign in first: gh auth login"; exit 1; }
gh api "orgs/$ORG" >/dev/null || { echo "Cannot read the organization $ORG."; exit 1; }

# The branch rules, modelled on the OdooTec logistics repository: the default branch cannot be deleted or
# force-pushed, every change goes through a pull request, and only repository admins may merge them.
ruleset_json() {
  cat <<'JSON'
{
  "name": "Protect the default branch",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
  "bypass_actors": [ { "actor_id": 5, "actor_type": "RepositoryRole", "bypass_mode": "pull_request" } ],
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    { "type": "update" },
    { "type": "pull_request", "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true,
        "allowed_merge_methods": ["squash", "merge"]
    } }
  ]
}
JSON
}

apply_rules() {
  local repo="$1" existing id
  existing="$(gh api "repos/$ORG/$repo/rulesets" 2>&1)" || {
    if grep -q "Upgrade to GitHub" <<<"$existing"; then
      warn "$repo: branch rules need GitHub Team for private repositories on an organization; skipped."
    else
      warn "$repo: could not read rulesets: $existing"
    fi
    return 0
  }
  id="$(gh api "repos/$ORG/$repo/rulesets" --jq '.[] | select(.name=="Protect the default branch") | .id')"
  if [[ -n "$id" ]]; then
    ruleset_json | api -X PUT "repos/$ORG/$repo/rulesets/$id" --input -
  else
    ruleset_json | api -X POST "repos/$ORG/$repo/rulesets" --input -
  fi
}

first_commit_and_push() {
  local repo="$1" dir="$2"
  [[ -d "$dir" ]] || { warn "$dir does not exist; nothing to push for $repo."; return 0; }
  pushd "$dir" >/dev/null
  [[ -d .git ]] || run git init -q -b main
  if ! git rev-parse --verify -q HEAD >/dev/null || [[ -n "$(git status --porcelain)" ]]; then
    run git add -A
    if git rev-parse --verify -q HEAD >/dev/null; then
      run git commit -q -s -m "Update ${repo}"
    else
      run git commit -q -s -m "Start ${repo}"
    fi
  fi
  local url="git@github.com:$ORG/$repo.git"
  if git remote get-url origin >/dev/null 2>&1; then
    run git remote set-url origin "$url"
  else
    run git remote add origin "$url"
  fi
  local remote_head
  remote_head="$(git ls-remote origin refs/heads/main 2>/dev/null | cut -f1 || true)"
  if [[ -n "$remote_head" ]] && ! git merge-base --is-ancestor "$remote_head" HEAD 2>/dev/null; then
    local count
    count="$(gh api "repos/$ORG/$repo/commits?per_page=2" --jq 'length' 2>/dev/null || echo 2)"
    if [[ "$count" == "1" && "${REPLACE_INITIAL:-0}" == "1" ]]; then
      say "$repo:" "replacing GitHub's initial commit with the local history"
      run git push -q --force-with-lease="main:$remote_head" -u origin main
    else
      warn "$repo: GitHub already has other commits on main. Pull them first (or, if it is only GitHub's" \
        "\"Initial commit\", rerun with REPLACE_INITIAL=1)."
    fi
  else
    run git push -q -u origin main
  fi
  popd >/dev/null
}

setup_teams() {
  if ! gh api "orgs/$ORG/teams" >/dev/null 2>&1 || ! gh auth status 2>&1 | grep -q "admin:org"; then
    warn "Teams need the admin:org scope. Run: gh auth refresh -h github.com -s admin:org   then run this script again."
    return 0
  fi
  local entry slug description repos repo
  for entry in "${TEAMS[@]}"; do
    IFS='|' read -r slug description repos <<<"$entry"
    if gh api "orgs/$ORG/teams/$slug" >/dev/null 2>&1; then
      api -X PATCH "orgs/$ORG/teams/$slug" -f description="$description" -f privacy=closed
    else
      api -X POST "orgs/$ORG/teams" -f name="$slug" -f description="$description" -f privacy=closed
    fi
    IFS=',' read -r -a repo_list <<<"$repos"
    for repo in "${repo_list[@]}"; do
      if gh repo view "$ORG/$repo" >/dev/null 2>&1; then
        api -X PUT "orgs/$ORG/teams/$slug/repos/$ORG/$repo" -f permission=push
      fi
    done
    say "  team $slug:" "write access to $repos (add people at github.com/orgs/$ORG/teams/$slug)"
  done
}

for entry in "${REPOS[@]}"; do
  IFS='|' read -r name folder visibility homepage description topics <<<"$entry"
  wanted "$name" "$folder" || continue
  say "→ $ORG/$name" "($visibility)"

  if gh repo view "$ORG/$name" >/dev/null 2>&1; then
    say "  exists," "updating its settings"
  else
    run gh repo create "$ORG/$name" "--$visibility" --description "$description" --disable-wiki
  fi

  api -X PATCH "repos/$ORG/$name" \
    -f description="$description" -f homepage="$homepage" \
    -F has_wiki=false -F has_projects=false -F has_issues=true \
    -F allow_squash_merge=true -F allow_merge_commit=true -F allow_rebase_merge=false \
    -F delete_branch_on_merge=true -F allow_update_branch=true \
    -F web_commit_signoff_required=true \
    -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=PR_BODY

  IFS=',' read -r -a topic_list <<<"$topics"
  topic_args=()
  for topic in "${topic_list[@]}"; do topic_args+=(-f "names[]=$topic"); done
  api -X PUT "repos/$ORG/$name/topics" "${topic_args[@]}"

  api -X PUT "repos/$ORG/$name/vulnerability-alerts" || warn "$name: Dependabot alerts not available."
  api -X PUT "repos/$ORG/$name/automated-security-fixes" || warn "$name: Dependabot security updates not available."

  for label in "${LABELS[@]}"; do
    IFS='|' read -r label_name colour label_description <<<"$label"
    if ((DRY_RUN)); then
      printf '  would set label %s\n' "$label_name"
    else
      gh label create "$label_name" --repo "$ORG/$name" --color "$colour" --description "$label_description" --force >/dev/null
    fi
  done

  first_commit_and_push "$name" "$ROOT/$folder"
  [[ "$name" == "sudoo-plugin-template" ]] && api -X PATCH "repos/$ORG/$name" -F is_template=true
  apply_rules "$name"
done

say "→ Teams"
setup_teams

say "Done." "Repository list: https://github.com/orgs/$ORG/repositories"
say "Organization settings that the API token cannot change:" "see ~/sudoo-github/ORG_SETTINGS.md"
