# Working in Sudoo.sh repositories

These rules apply to every repository of the organization unless a repository has its own CONTRIBUTING.md.

## Branches and pull requests

- `main` is protected: it cannot be deleted or force-pushed, and every change reaches it through a pull request.
  Only repository admins merge.
- Work on a branch named after the change: `feat/...`, `fix/...`, `docs/...`, `chore/...`, `security/...`.
- One topic per pull request. Fill in the template: what changed, why, how it was checked.
- Squash-merge by default; the pull request title becomes the commit title, so write it as a sentence.
- Branches are deleted after merging.

## Commits

- Sign off every commit (`git commit -s`); GitHub refuses web commits without it.
- Plain, specific messages: what changed and why, not how.

## Quality gates (CI must pass before merging)

- Lint, type-check, tests and build, as each repository's `.github/workflows/ci.yml` defines.
- User-visible changes: update the repository's README or docs, and its CHANGELOG when it has one, in the same pull
  request.
- No secrets, `.env` files, keys, certificates, database dumps or backups in Git, ever. Use `.env.example`.
- Latest stable dependencies; Node.js LTS only.

## Design

Every web property uses the shared design tokens (`sudoo-tokens.css`, copied unchanged from the panel) and the
Sudoo.sh mark, and follows the design and motion rules in the panel's `docs/DESIGN.md`.

## Security

Report vulnerabilities privately, never in a public issue: see [SECURITY.md](SECURITY.md).
