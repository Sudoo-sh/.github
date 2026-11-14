# Organization settings

`scripts/setup-github.sh` does everything the GitHub API allows with a normal token: repositories, descriptions,
websites, topics, merge settings, labels, Dependabot, branch rules and the first push. The settings below live in
the organization's web pages only. Do them by hand, or give the prompt at the end to the Claude browser extension.

| Where (github.com/organizations/Sudoo-sh/settings/...) | Set | Why |
| :--- | :--- | :--- |
| `profile` | Website `https://sudoo.sh`; profile picture `profile/avatar.png`; keep the description | The page people land on |
| `authentication_security` | Require two-factor authentication for everyone | A stolen password alone cannot reach the code |
| `member_privileges` | Base permissions **No permission**; repository creation **Private** only; forking of private repositories **off**; pages creation **off** | Private repositories stay visible only to the people added to them |
| `security_analysis` | For new repositories: Dependency graph, Dependabot alerts, Dependabot security updates **on**; for public repositories also Secret scanning and Push protection **on** | Vulnerable packages and leaked keys are caught automatically |
| `actions` | Allow actions created by GitHub and **verified** creators only; workflow permissions **Read** by default | A compromised third-party action cannot write to the repositories |
| `domains` | Verify `sudoo.sh` once the domain is yours (a DNS TXT record) | The "Verified" badge, and e-mail notifications restricted to the domain |
| Repository `Sudoo-sh/sudoo.sh` → Settings → Security | Private vulnerability reporting **on** | SECURITY.md points there |

**Plan:** branch rules (rulesets) on private repositories need **GitHub Team** (paid, per member). On the free plan
the script applies them to the public repositories (`sudoo.sh`, `.github`) and reports the private ones as skipped.

## Prompt for the Claude browser extension

> Open github.com in my already signed-in browser and configure the organization **Sudoo-sh** exactly as follows.
> Do not change anything else, do not delete anything, and stop and ask me before any step that asks for my
> password, a 2FA code, a payment, or a confirmation of a destructive action.
>
> 1. Organization settings → Profile: set Website to `https://sudoo.sh`. Leave the name, description and e-mail as
>    they are. (I will upload the profile picture myself.)
> 2. Settings → Authentication security: tick "Require two-factor authentication for everyone in the Sudoo-sh
>    organization" and save. If GitHub warns that members without 2FA will be removed, tell me who before saving.
> 3. Settings → Member privileges: Base permissions = "No permission"; Repository creation = allow members to create
>    Private repositories only (untick Public); "Allow forking of private repositories" = off; Pages creation = off.
>    Save each section.
> 4. Settings → Code security (Global settings / Advanced security): for new repositories enable Dependency graph,
>    Dependabot alerts and Dependabot security updates; for new public repositories enable Secret scanning and Push
>    protection. Do not enable anything that asks for payment.
> 5. Settings → Actions → General: "Allow Sudoo-sh, and select non-Sudoo-sh, actions and reusable workflows" with
>    "Allow actions created by GitHub" and "Allow actions by Marketplace verified creators" ticked; Workflow
>    permissions = "Read repository contents and packages permissions". Save.
> 6. Open the repository Sudoo-sh/sudoo.sh → Settings → Code security → enable "Private vulnerability reporting".
> 7. When done, list every setting you changed with its old and new value, and anything you could not change.
