# Graduated Review Authority

A single-page explainer for **Graduated Review Authority (GRA)**, a governance model for AI-native software delivery that matches how much review a change needs to the risk it carries and the evidence behind it.

> **The published page at [gra.dev](https://gra.dev) is the authoritative source for this content.** This repository holds the static site that builds it. When the two differ, [gra.dev](https://gra.dev) is correct.

## What this is

In AI-native delivery, code is generated faster than people can review it. Reviewing every change the same way is both slow and unsafe. GRA replaces the single fixed review path with a graduated one: low-risk, well-evidenced changes move quickly, while high-risk changes still get human judgment.

The page walks through the model in nine sections:

1. **What it is**: review depth decided by objective evidence, not by who or what wrote the change
2. **Why it exists**: the two failure modes of unadapted review
3. **The core idea**: generation is not authority; the pipeline is the authority
4. **Three sources of evidence**: deterministic gates, agent review, human review
5. **How a change earns its review level**: the signals that route a change to auto-eligible, agent, or human review
6. **When human review is always required**: auth, money, regulated data, migrations, broad architecture, ambiguity
7. **How authority grows and shrinks**: track record raises or lowers oversight, but never below what risk demands
8. **Where this connects to planning**: how dual-complexity sizing estimates review load and predicts the GRA level
9. **What it is not**: clearing up common misreadings

## Project structure

| File | Purpose |
| --- | --- |
| `index.html` | The full page content and structure |
| `index.html.md` | Markdown mirror of the page for LLMs, per the llmstxt.org spec |
| `styles.css` | All styling, design tokens, and responsive layout |
| `main.js` | Optional conveniences for the navigation menu (close on selection, Escape, or outside click), and a cookieless GoatCounter analytics loader that honors Do Not Track and Global Privacy Control |
| `favicon.svg` | Site favicon, a graduated three-bar mark in the review-level colors |
| `fonts/` | Self-hosted Inter (latin subset, variable weight) so the page loads no third-party fonts |
| `robots.txt` | Crawler directives and a pointer to the sitemap |
| `sitemap.xml` | Sitemap listing the single canonical URL for search engines |
| `llms.txt` | LLM-friendly overview of the model and key links, per the llmstxt.org spec |

This is a dependency-free static site with no build step, no framework, and no package manager. It is plain HTML, CSS, and ES modules.

## Keeping the content in sync

`index.html` and `index.html.md` are hand-maintained copies of the same content, so they must change together. Two safeguards enforce this:

- A local `pre-commit` hook that blocks a commit which touches one file but not the other. Activate it once after cloning:

```bash
./scripts/install-hooks.sh
```

  The hook lives in `.githooks/pre-commit`. Bypass it for an intentional one-sided change with `git commit --no-verify`.

- A `Content sync check` GitHub Actions workflow that fails a push or pull request when only one of the two files changed.

## Running locally

Open `index.html` directly in a browser, or serve the folder over HTTP so the ES module imports resolve:

```bash
python3 -m http.server 8000
```

Then visit `http://localhost:8000`.

## Accessibility

The page is built to be usable without JavaScript. The navigation is a native `<details>` disclosure that opens and closes on its own; JavaScript only adds conveniences such as closing on selection, Escape, or an outside click, and the page remains fully navigable if it does not run. The markup uses semantic landmarks, a skip link, labelled sections, and respects `prefers-reduced-motion` and `prefers-color-scheme`.
