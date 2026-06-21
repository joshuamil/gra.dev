# Graduated Review Authority

A single-page explainer for **Graduated Review Authority (GRA)** — a governance model for AI-native software delivery that matches how much review a change needs to the risk it carries and the evidence behind it.

> **The published page at [gra.dev](https://gra.dev) is the authoritative source for this content.** This repository holds the static site that builds it. When the two differ, [gra.dev](https://gra.dev) is correct.

## What this is

In AI-native delivery, code is generated faster than people can review it. Reviewing every change the same way is both slow and unsafe. GRA replaces the single fixed review path with a graduated one: low-risk, well-evidenced changes move quickly, while high-risk changes still get human judgment.

The page walks through the model in eight sections:

1. **What it is** — review depth decided by objective evidence, not by who or what wrote the change
2. **Why it exists** — the two failure modes of unadapted review
3. **The core idea** — generation is not authority; the pipeline is the authority
4. **Three sources of evidence** — deterministic gates, agent review, human review
5. **How a change earns its review level** — the signals that route a change to auto-eligible, agent, or human review
6. **When human review is always required** — auth, money, regulated data, migrations, broad architecture, ambiguity
7. **How authority grows and shrinks** — track record raises or lowers oversight, but never below what risk demands
8. **What it is not** — clearing up common misreadings

## Project structure

| File | Purpose |
| --- | --- |
| `index.html` | The full page content and structure |
| `styles.css` | All styling, design tokens, and responsive layout |
| `main.js` | Entry point; wires up progressive enhancement |
| `section-nav.js` | Highlights the in-page nav link for the section currently in view |

This is a dependency-free static site — no build step, no framework, no package manager. It is plain HTML, CSS, and ES modules.

## Running locally

Open `index.html` directly in a browser, or serve the folder over HTTP so the ES module imports resolve:

```bash
python3 -m http.server 8000
```

Then visit `http://localhost:8000`.

## Accessibility

The page is built to be usable without JavaScript. Section-nav highlighting is purely a visual aid layered on top via `IntersectionObserver`; the page remains fully navigable if it does not run. The markup uses semantic landmarks, a skip link, labelled sections, and respects `prefers-reduced-motion` and `prefers-color-scheme`.
