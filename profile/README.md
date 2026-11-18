<p align="center">
  <a href="https://github.com/Sudoo-sh/sudoo.sh"><picture><source media="(prefers-color-scheme: dark)" srcset="mark-animated-dark.svg"><img src="mark-animated.svg" alt="Sudoo.sh" width="88" height="88"></picture></a>
</p>

<h3 align="center">Every Odoo environment your team needs, on one server you own.</h3>

<p align="center">
Demos, test branches, training and customer previews: each one a running Odoo with its own HTTPS link,<br>
for the price of your server instead of a bill per environment.
</p>

<p align="center">
  <a href="https://github.com/Sudoo-sh/sudoo.sh#quick-start"><b>Quick start</b></a> ·
  <a href="https://github.com/Sudoo-sh/sudoo.sh#why-sudoosh">Why Sudoo.sh</a> ·
  <a href="https://github.com/Sudoo-sh/sudoo.sh/tree/main/docs">Documentation</a> ·
  <a href="https://github.com/Sudoo-sh/sudoo.sh/blob/main/SECURITY.md">Security</a>
</p>

---

### The problem

Odoo teams rarely need just one test database. Partners want a fresh demo per prospect, developers want every
feature branch running, trainers want one per class. On hosted platforms each extra staging environment adds to the
monthly bill, so teams ration them: demos are deleted too early and features share one staging.

### What Sudoo.sh does

- **A running Odoo per branch** in about two minutes: any version from 16.0, Community or Enterprise, or plain Odoo
  without a repository.
- **Its own HTTPS link** for every instance, updated on every push through the GitHub App, a webhook or polling.
- **Idle instances pause themselves** and wake on the next visit, so one ordinary server holds dozens of them.
- **Daily backups** with one-click restore and rollback, and a lifetime after which demos delete themselves.
- **Made for teams:** five roles, second factors, an audit log and a signed REST API.
- **Inside your Odoo:** free [apps on the Odoo Apps store](https://apps.odoo.com/apps/modules/browse?author=Sudoo.sh)
  create a demo from an opportunity, or a test instance from a task or a ticket (Odoo 17.0 to 20.0, English and
  Arabic).

| | Hosted, billed per environment | Sudoo.sh |
| :--- | :--- | :--- |
| One more demo or test branch | adds to the monthly bill | costs nothing extra |
| Environments nobody uses | billed while idle | paused, using no memory |
| Where your code and data live | the provider's cloud | your server |

### Get started

On Ubuntu 22.04+ or Debian 12+:

```bash
curl -fsSL https://github.com/Sudoo-sh/sudoo.sh/releases/latest/download/sudoo-install.sh | sudo bash
```

The installer asks before installing anything, then prints the panel's link and a setup code. To check the script
before running it, see [Quick start](https://github.com/Sudoo-sh/sudoo.sh#quick-start).

### Repositories

| | |
| :--- | :--- |
| [**sudoo.sh**](https://github.com/Sudoo-sh/sudoo.sh) | The panel: create, update, pause, back up and share Odoo instances |
| [**sudoo-plugin-sdk**](https://github.com/Sudoo-sh/sudoo-plugin-sdk) | Build plugins for the panel (Apache-2.0) |
| [**sudoo-plugin-template**](https://github.com/Sudoo-sh/sudoo-plugin-template) | A ready-to-use starting point for a new plugin (MIT-0) |
| [**sudoo-odoo**](https://github.com/Sudoo-sh/sudoo-odoo) | The apps for Odoo: [Instance Manager](https://apps.odoo.com/apps/modules/20.0/sudoo_base), [CRM Demos](https://apps.odoo.com/apps/modules/20.0/sudoo_crm), [Project Tests](https://apps.odoo.com/apps/modules/20.0/sudoo_project), [Helpdesk Tests](https://apps.odoo.com/apps/modules/20.0/sudoo_helpdesk) (free, OPL-1) |

---

<sub>Free for personal and noncommercial use under the
<a href="https://github.com/Sudoo-sh/sudoo.sh/blob/main/LICENSE.md">PolyForm Noncommercial 1.0.0</a> licence; companies
need a commercial licence. For development, demos, tests and training, not production. © 2026 Sudoo.sh.
Not affiliated with Odoo S.A.; Odoo is a trademark of Odoo S.A.</sub>
