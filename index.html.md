# Graduated Review Authority

> A governance model for AI-native delivery.

When software is generated faster than people can review it, treating every change the same way is wasteful and unsafe. Graduated Review Authority decides *how much review a change needs* from the risk it carries and the evidence behind it. Low-risk work moves quickly, and high-risk work still gets human judgment.

The authoritative version of this content is published at https://gra.dev/.

## 01. What it is

Graduated Review Authority (GRA) is a way of deciding how thoroughly a code change must be reviewed before it ships, based on objective evidence rather than on who, or what, wrote it.

In most teams every change follows the same path: a person writes it, another person reviews it, and it merges. That made sense when writing code was the slow, expensive step. In AI-native delivery, generation is fast and cheap, and human review becomes the bottleneck. GRA replaces the single fixed path with a **graduated** one: the amount and depth of review scales up or down with the risk of the change and the strength of the evidence that it is correct.

A trivial copy fix that passes every automated check does not need the same scrutiny as a change to how payments are calculated. GRA makes that difference explicit, consistent, and defensible.

## 02. Why it exists

AI agents can now produce large volumes of working code. That shifts the constraint in software delivery away from *writing* and onto *verifying*. Two failure modes appear when review does not adapt:

- **Reviewing everything equally is too slow.** When every change waits for the same full human review, the queue grows faster than people can clear it. Safe, obvious changes sit behind risky ones, and the speed advantage of generation is lost to the review backlog.
- **Reviewing nothing carefully is unsafe.** The opposite reflex, trusting the agent and waving changes through, lets high-risk work reach production without the judgment it needs. Authentication, money, and regulated data do not become low-risk just because an AI is confident.

GRA exists to resolve this tension. It keeps humans focused on the changes where their judgment matters most, and stops asking them to re-check the things a machine can verify objectively. The purpose is not to remove people from delivery. It is to spend their attention where it is most valuable.

## 03. The core idea

**Generation is not authority. The pipeline is the authority.**

Anyone, whether a person or an agent, can write code, tests, or a remediation plan. Producing something does not grant permission to ship it. In GRA, approval comes only from passing defined validation, and review authority is **earned through demonstrated reliability**, not assumed because the author is human or because the author is AI.

This reframes the question a team asks about every change. The question is not "*can the AI do this?*" It is "*has this change produced enough objective evidence to safely reduce human review?*"

It also settles who is in control. Writing a change and deciding whether it may ship are different jobs. The decision of what happens next, whether to retry, advance, or stop for a person, is made by deterministic control, never by the model whose work is under review. A model can propose; it cannot grant itself passage.

## 04. Three sources of evidence

GRA weighs three kinds of evidence about whether a change is safe. They are not equal: deterministic checks are the strongest, human judgment is reserved for where it is genuinely needed.

1. **Deterministic gates (strongest).** Type checking, linting, formatting, unit and integration tests, security and secrets scans, compliance and policy checks. They give the same answer every time, so a failure can block a release outright, and no opinion overrides it.
2. **Agent review (supporting).** An agent can flag risks, missing tests, unclear requirements, and security or architectural concerns. This is useful but probabilistic, so it counts as review evidence that informs decisions rather than as final authority, and only when the reviewing agent is independent of the one that wrote the change.
3. **Human review (reserved for judgment).** People focus on what machines cannot settle: risk, ambiguity, architecture, and business intent. Human review is required wherever a change is risky enough to demand it, and is not spent re-checking what the gates already proved.

For that ordering to mean anything, the evidence has to be hard to fake. The checks a change must pass are fixed before the change is written, so the author cannot quietly soften them to clear a gate. And when a required deterministic check is missing or cannot run, the change is blocked rather than waved through on a model's say-so: absent evidence is not the same as evidence of safety.

## 05. How a change earns its review level

The review a change requires is not fixed by its size alone. It is shaped by a set of signals about how risky and how well-understood the change is:

- Risk of the change
- Criticality of the affected system
- Confidence from deterministic validation
- Quality of test coverage
- Security and compliance exposure
- Historical success of similar changes
- Novelty or ambiguity of the work

Weighed together, those signals point a change toward one of three levels of review. Lower levels are only reachable when the evidence supports them; risk or a failed gate always pulls a change back up toward human review.

Correcting a failed gate is expected, but the attempt is bounded. When a change cannot reach a clean pass within that budget, the repeated failure is itself a signal: the change escalates to a person rather than looping indefinitely.

The three review levels, from least to most human oversight:

- **Auto-eligible:** Low-risk change that passed every gate cleanly.
- **Agent review:** Moderate scope where deterministic plus agent review is sufficient.
- **Human review:** High risk, ambiguity, or any failed validation.

## 06. When human review is always required

Some categories of change carry enough inherent risk that no amount of automated confidence can lower them. These always route to a person, regardless of how clean the gates are:

- **Authentication and authorization:** Login, sessions, permissions, tokens, and access control.
- **Money movement:** Billing, payments, commissions, payouts, and pricing.
- **Regulated data:** PCI, PHI, HIPAA, SOC, and other compliance-sensitive information.
- **Migrations and destructive operations:** Production data migrations and anything irreversible.
- **Broad architectural change:** Wide-reaching changes that affect many systems at once.
- **Ambiguity and repeated failure:** Unclear requirements, novel patterns, or repeated remediation loops.

## 07. How authority grows and shrinks

"Graduated" is the key word: authority is not granted once and kept forever. It moves with the track record of a kind of change.

- **Authority increases when** similar changes consistently pass deterministic validation, agent review, security and compliance checks, any required human review, and post-merge quality signals. A reliable history earns lighter-touch review.
- **Authority decreases when** changes produce regressions, repeated failures, escaped defects, policy violations, or excessive remediation loops. A weak track record earns more oversight, never less.

Authority is tracked against **classes of change**, not against authors. A class is defined by what a change touches and how much risk it carries, its area, its criticality, its size, never by whether a person or an agent produced it. Trust is earned by a kind of work with a real history behind it; it is never assumed for a particular author, human or AI.

How a change passes matters as much as whether it passes. Clearing every gate on the first attempt is stronger evidence than arriving there after repeated correction, and authority should rise only on sustained success after a change ships, no regressions and no escaped defects, not on a clean run before merge alone.

Improvement is judged by **outcomes**: fewer escaped defects and fewer correction loops. A falling number of findings is not progress on its own, because it can equally mean that detection has weakened. Only outcomes tell the two apart.

The pipeline graduates as well. A weakness that keeps surfacing is converted into a stronger, earlier, deterministic check, so that what once needed judgment becomes something the gates settle on their own. Each escaped problem becomes the test that catches the next one.

Crucially, the system can only ever **tighten** review based on a poor history. It never loosens review below what the risk of a change demands.

## 08. Where this connects to planning

GRA decides how much review a change needs at merge time. Long before that, teams have to estimate the work, and the model they use to size it is built on the same instinct about risk.

That model is **dual-complexity sizing**. It lives in the delivery tooling rather than in GRA itself, and despite the overlapping initials it is a separate idea. Instead of collapsing a task into one velocity number, it scores two independent axes. **Generation load (G)** measures how much net-new surface an agent has to build: endpoints, schema, components, and UI. It is a proxy for blast radius. **Review load (R)** measures how much a person has to verify before trusting the result, such as cross-team contracts, data-integrity and security risk, and ambiguity. Each axis is scored on the same short scale.

How each axis is scored:

| Score | Generation load (G) | Review load (R) |
| --- | --- | --- |
| 1 | Trivial: config or copy | Self-evident; tests cover it |
| 2 | Small: one surface | Local; one reviewer |
| 3 | Moderate: a few surfaces | Some ambiguity or edge cases |
| 5 | Large: a multi-surface feature | An owned contract; integration risk |
| 8 | Cross-cutting: schema and flows | A cross-team contract or security and data-integrity risk |

The two axes combine into a single estimate: **story points are the Fibonacci value of R, stepped up one notch when G reaches 5 or more**. Review load sets the floor; heavy generation only adds a margin on top. A small build that touches a cross-team contract (G 3, R 8) still scores 8 points, because the review is what dominates, while a large but self-contained feature (G 5, R 3) lands at 5.

The review-load axis is also the earliest read on GRA. The heavier the review a change is expected to need, the higher the level it is likely to land in:

- **Low review load (R 1-2):** Self-evident, locally scoped change. Estimated toward auto-eligible: light gates and, at most, a peer glance.
- **Moderate review load (R 3-5):** Some ambiguity or an owned contract. Estimated toward agent review and a standard gate with a contract check.
- **High review load (R 8+):** Cross-team contract or security and data-integrity risk. Estimated toward human review and senior sign-off.

The mapping is a prediction, not a decision. GRA still evaluates the real evidence at merge time: a failed gate or a mandatory-human category always pulls a change back up, regardless of how it was sized. And generation load never enters that decision; it shapes effort and points only, which keeps the review a change earns tied to its risk and evidence rather than to its size.

## 09. What it is not

Because the idea is easy to misread, it is worth being precise about what Graduated Review Authority does *not* mean:

- It does not mean AI approves everything.
- It does not make human review disappear.
- It does not let prompts replace tests.
- It does not let natural-language rules replace deterministic gates.
- It does not let a change weaken the tests that judge it.
- It does not let an author, human or AI, review its own work.
- It does not fall back to opinion when a required check cannot run.
- It does not let a confidence score override failed validation.
- It does not put speed ahead of correctness.

## 10. Part of a wider shift

GRA is not an isolated idea. It is one answer to a problem the industry is now naming directly: when AI generates code faster than an organization can verify it, the constraint on delivery moves from *writing* software to *trusting* it. [Brenn Hill](https://brennhill.substack.com) calls that distance the [delivery gap](https://www.amazon.com/Delivery-Gap-Adoption-Engineering-Leaders-ebook/dp/B0GWRY2XH1) in his book of the same name, and argues that the teams who pull ahead are the ones who build verification to match their generation speed, not the ones who simply adopt more tools.

GRA and that work address different layers of the same problem. Closing the delivery gap means building verification infrastructure and measuring whether it keeps pace with generation: Hill's focus on the cost and reliability of every *accepted change*, rather than vanity metrics such as raw pull-request volume, is how a team knows it does. GRA is the **routing layer** that sits on top of that infrastructure. Given a change and the evidence behind it, GRA decides **how much review the change actually needs**. One discipline measures whether your verification can be trusted; the other spends that trust where it counts. GRA assumes the infrastructure is there. It does not replace the work of building it.

---

The question GRA asks of every change is not "can the AI do this?" but "has this change earned a lighter review?"

A concept by [Josh Miller](https://www.linkedin.com/in/joshuamil/).
