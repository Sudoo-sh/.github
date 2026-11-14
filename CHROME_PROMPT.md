# Prompt for the Claude browser extension

Paste everything inside the quote into the extension while signed in to GitHub as an owner of Sudoo-sh. It creates
the repositories and sets their details; pushing the code is done afterwards from the computer with
`~/sudoo-github/scripts/setup-github.sh` (it skips creation for repositories that already exist).

> Work in my already signed-in GitHub, organization **Sudoo-sh**. Do exactly the steps below and nothing else. Never
> delete or rename anything, never change visibility of an existing repository, never pay or start a trial, and stop
> and ask me before any page that asks for my password or a 2FA code.
>
> **A. Create these repositories** (github.com/organizations/Sudoo-sh/repositories/new). For each: owner Sudoo-sh,
> the name and description below, the visibility below, **no** README, **no** .gitignore, **no** licence (the code
> already has them). If a repository with that name already exists, do not create it; go to its settings instead
> and apply section B.
>
> | Name | Visibility | Description | Website | Topics |
> |---|---|---|---|---|
> | .github | Public | Profile and shared community files of the Sudoo.sh organization. | https://sudoo.sh | sudoo, organization, community |
> | sudoo-website | Private | The sudoo.sh website: product, features, pricing, plugins, legal. Astro, static, strict CSP. | https://sudoo.sh | sudoo, odoo, website, astro, static-site, seo |
> | sudoo-docs | Private | docs.sudoo.sh: the Sudoo.sh documentation, built from the panel's docs with VitePress. | https://docs.sudoo.sh | sudoo, odoo, documentation, vitepress |
> | sudoo-marketplace | Private | marketplace.sudoo.sh: the catalogue of signed plugins for Sudoo.sh. Next.js. | https://marketplace.sudoo.sh | sudoo, odoo, marketplace, plugins, nextjs |
> | sudoo-developers | Private | developers.sudoo.sh: publish plugins, follow analytics and payouts. Next.js. | https://developers.sudoo.sh | sudoo, odoo, developer-portal, plugins, nextjs |
> | sudoo-account | Private | app.sudoo.sh: servers, licences, plugins, billing and team of a Sudoo.sh account. Next.js. | https://app.sudoo.sh | sudoo, odoo, dashboard, billing, nextjs |
> | sudoo-hub | Private | hub.sudoo.sh: accounts, panel registration and heartbeats, licences, signed plugin catalogue. FastAPI. | https://hub.sudoo.sh | sudoo, odoo, fastapi, postgresql, redis, ed25519, licensing |
> | sudoo-cluster | Private | Docker Compose, Nginx and Certbot stack that hosts every *.sudoo.sh property on one server. | (none) | sudoo, docker-compose, nginx, certbot, infrastructure |
> | sudoo-status | Private | status.sudoo.sh: uptime and certificate checks of every Sudoo.sh property, with Gatus. | https://status.sudoo.sh | sudoo, status-page, gatus, monitoring |
> | sudoo-plugin-sdk | Private | SDK and CLI for building Sudoo.sh plugins: manifest types, base classes, test harness, packing. | https://docs.sudoo.sh | sudoo, plugins, sdk, python |
> | sudoo-plugin-template | Private | Start a Sudoo.sh plugin: a working example, CI, and a release workflow for the marketplace. | https://developers.sudoo.sh | sudoo, plugins, template |
> | sudoo-plugins | Private | The official Sudoo.sh plugins (mailer, second factors, tunnels, API, MCP, themes), one folder each. | https://marketplace.sudoo.sh | sudoo, odoo, plugins |
>
> **B. For every repository in the table** (also the existing ones), open Settings:
> 1. General → About (the gear next to "About" on the repository's main page): set Website and Topics from the table.
> 2. General → Features: untick **Wikis** and **Projects**; keep **Issues** on.
> 3. General → Pull Requests: tick **Allow merge commits** and **Allow squash merging** (squash default message
>    "Pull request title and description"); untick **Allow rebase merging**; tick **Always suggest updating pull
>    request branches** and **Automatically delete head branches**.
> 4. General → tick **Require contributors to sign off on web-based commits**.
> 5. Code security: enable **Dependency graph**, **Dependabot alerts** and **Dependabot security updates** where
>    offered without payment. For public repositories also **Secret scanning**, **Push protection** and **Private
>    vulnerability reporting**.
> 6. Rules → Rulesets → New branch ruleset (skip with a note if GitHub says it needs a paid plan):
>    name **Protect the default branch**, enforcement **Active**, bypass list **Repository admin** with "For pull
>    requests only", target branches **Include default branch**, and tick: **Restrict deletions**, **Restrict
>    updates**, **Block force pushes**, **Require a pull request before merging** (0 approvals, tick "Require
>    conversation resolution before merging", allowed merge methods Merge and Squash). Save.
> 7. sudoo-plugin-template only: General → tick **Template repository**.
>
> **C. Organization settings** (github.com/organizations/Sudoo-sh/settings): Profile website `https://sudoo.sh`;
> Authentication security → require two-factor authentication (tell me who would be removed before saving);
> Member privileges → base permissions **No permission**, members may create **private** repositories only, forking
> of private repositories **off**; Actions → allow GitHub-created and Marketplace-verified actions only, workflow
> permissions **Read**.
>
> **D. Teams** (github.com/orgs/Sudoo-sh/teams → New team; visibility Visible, no parent team). I stay the only
> organization owner; do not add anyone as owner or as a member. Create:
> - **core-devs** ("Developers of the panel, the hub and the infrastructure") with **Write** on sudoo.sh, sudoo-hub,
>   sudoo-cluster, sudoo-status
> - **web-devs** ("Developers of the websites and web apps") with **Write** on sudoo-website, sudoo-docs,
>   sudoo-marketplace, sudoo-developers, sudoo-account
> - **plugin-devs** ("Developers of the plugin SDK, the template and the official plugins") with **Write** on
>   sudoo-plugin-sdk, sudoo-plugin-template, sudoo-plugins
> (Team → Repositories → Add repository → choose the role Write.)
>
> **E. Report** a table: repository, created or already existed, each setting changed, and anything skipped with the
> reason GitHub gave.
