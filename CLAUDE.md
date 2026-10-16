# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

The import above (`AGENTS.md`, which itself defers to `.github/copilot-instructions.md` and `docs/BOUNDARIES.md`) is the canonical short entry point: ownership boundaries, the validated command set, and PR-routing rules. Everything below is Claude-specific context that those files assume but don't spell out.

## What this repo is

This is **Alessio Cocchieri's personal academic website**, deployed at `https://alessiococchieri.github.io`. It is a customized fork of the `al-folio` v1.x Jekyll starter — not the upstream al-folio project itself.

Key distinction from upstream: the site's `baseurl` is blank (deployed at root). All dev commands below reflect this; do **not** use `--baseurl /al-folio`.

The site owner is an NLP PhD researcher at UniboNLP, University of Bologna, working on LLM evaluation, benchmarking, and low-resource NLP.

## Personal content locations

The al-folio demo content (blog posts, projects, teaching, books, Einstein placeholder data) has been removed; the site only has about, publications, news and CV pages.

When asked to update the site content, edit these files:

| Content type         | File(s)                                                                                      |
| -------------------- | -------------------------------------------------------------------------------------------- |
| Homepage bio         | `_pages/about.md`                                                                            |
| Publications list    | `_bibliography/papers.bib`                                                                   |
| CV (PDF)             | `assets/pdf/Personal_CV_Alessio_Cocchieri.pdf` (`/cv/` redirects to it via `_pages/cv.html`) |
| News / announcements | `_news/*.md`                                                                                 |
| Site-wide settings   | `_config.yml` (name, social links, feature flags, analytics)                                 |
| Social links / theme | `_config.yml` under `social:` / `theme:` blocks                                              |

## Dev commands (for this site)

```bash
bundle install                    # install ruby gems
bundle exec jekyll serve          # dev server → http://localhost:4000/
bundle exec jekyll build          # build to _site/
npm ci                            # install node tools
npm run lint:prettier             # check formatting
npm run lint:style-contract       # verify starter boundary rules
```

Running a specific integration test:

```bash
bash test/integration_plugin_toggles.sh  # plugin enable/disable
bash test/integration_bootstrap_compat.sh
bash test/integration_upgrade_cli.sh
```

Visual regression (Playwright):

```bash
npx playwright install chromium webkit
npm run test:visual
npm run test:visual:update   # refresh snapshots after intentional UI change
```

Upgrade tooling:

```bash
bundle exec al-folio upgrade audit
bundle exec al-folio upgrade apply --safe   # deterministic codemods
bundle exec al-folio upgrade report
```

## What this repo owns vs what the gems own

**Edit here:** `_config.yml`, `_pages/`, `_posts/`, `_projects/`, `_news/`, `_teachings/`, `_books/`, `_bibliography/`, `_data/`, `assets/`, `docs/`, and integration/visual tests.

**Do not edit here:** layouts, includes, Sass, JS feature code, and Liquid tags — those live in versioned gems. If a layout or include needs fixing, the fix belongs in the owning gem (see the plugin table in `docs/BOUNDARIES.md`). Local site overrides are allowed but must be tracked: run `bundle exec al-folio upgrade overrides audit` and commit `.al-folio-overrides.yml`.

## The plugin ecosystem

**`al_folio_core` is the hub.** `_config.yml` sets `theme: al_folio_core`; the gem ships all base `_layouts/*.liquid`, `_includes/*.liquid`, base JS/CSS, and core Liquid tags/filters. Sibling gems provide feature extensions via thin wrapper includes in `_includes/plugins/*.liquid`.

Feature gating is two-layered: site-wide flags in `_config.yml` (e.g. `enable_math`, `search_enabled`, `enable_darkmode`) **and** per-page front matter (`tikzjax`, `chart.*`, `mermaid.*`, `giscus_comments`). A disabled feature emits an empty string — it fails silently, not loudly.

Two lists must stay in sync when adding or removing a plugin: `Gemfile` (pinned version) and `_config.yml`'s `plugins:` list.

| Feature                | Gem                         |
| ---------------------- | --------------------------- |
| Search (Cmd-K)         | `al_search`                 |
| Comments               | `al_comments`               |
| Cookie consent         | `al_cookie`                 |
| Icons (FA/Academicons) | `al_icons`                  |
| Analytics              | `al_analytics`              |
| Math (MathJax/TikZ)    | `al_math`                   |
| Charts                 | `al_charts`                 |
| Image tools            | `al_img_tools`              |
| Newsletter             | `al_newsletter`             |
| CV layout              | `al_folio_cv`               |
| Distill layout         | `al_folio_distill`          |
| Citation badges        | `al_citations`              |
| External posts         | `al_ext_posts`              |
| Bootstrap compat       | `al_folio_bootstrap_compat` |
| Upgrade/audit CLI      | `al_folio_upgrade`          |

## CI gates

| Workflow                | What it checks                                                  |
| ----------------------- | --------------------------------------------------------------- |
| `unit-tests.yml`        | Style contract + integration scripts in `test/`                 |
| `visual-regression.yml` | Playwright chromium+webkit against baseline                     |
| `upgrade-check.yml`     | `al-folio upgrade audit`                                        |
| `prettier.yml`          | Prettier (`@shopify/prettier-plugin-liquid`, `printWidth: 150`) |
| `deploy.yml`            | Production build and GitHub Pages push                          |

Run `npm run lint:prettier` before pushing. The style contract (`npm run lint:style-contract`) will fail CI if starter files stray into gem-owned territory (adding `build:css` npm scripts, owning `_includes/`, `_layouts/`, `_sass/`, etc.).

## Docker (optional local dev)

```bash
docker compose up -d
curl -fsS http://127.0.0.1:8080/ >/dev/null   # verify (blank baseurl → root path)
docker compose logs --tail=80
docker compose down
```

Build output goes to container-local `/tmp/_site`, not the bind-mounted `_site/`, to avoid write deadlocks. The container also watches `_config.yml` and restarts Jekyll on change.
