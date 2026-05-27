---
description: Generate SR&ED-quality notes from branch diff (main..HEAD) and user notes
alwaysApply: false
---

# SR&ED Notes from Branch Changes

When asked to create or draft SR&ED notes for the current branch, follow this workflow.

## 1. Get the diff

Run in the repo root:

```bash
git diff origin/main..HEAD
```

Use this as the primary source of what changed. If the user specifies a different base branch (e.g. `develop`), use that instead.

## 2. Gather user context

- **User notes in this chat**: The user may describe approaches they tried that didn’t work, dead ends, or who helped. Treat these as first-hand iteration details and weave them into the SR&ED notes (e.g. under “Why it failed” or “Next iteration”).
- If the user only provides the diff (no extra notes), infer plausible iterations from the code changes and commit context where reasonable; otherwise label clearly that iteration details should be filled in.

## 3. Tag each piece of work

Assign exactly one tag per item:

| Tag         | Use when                                        |
| ----------- | ----------------------------------------------- |
| `[FEATURE]` | New logic, new functionality, new integrations  |
| `[BUG]`     | Fixing incorrect or unexpected behavior         |
| `[SPIKE]`   | Prototyping, feasibility, or investigation work |
| `[INFRA]`   | CI/CD, deployment, scaling, cloud/infra changes |

## 4. Write SR&ED-quality notes (iterations matter)

For each **distinct piece of work** in the diff (one note per feature/bug/spike/infra change, not per file):

1. **Scenario** – Short label (e.g. “API Integration”, “Database Query”, “UI Performance”).
2. **Weak note** – One sentence that would _not_ qualify as SR&ED (e.g. “Integrated Stripe API”, “Optimized SQL query”). Include this so the user sees what to avoid.
3. **SR&ED-quality note** – One or two sentences in this shape:
   - **`[TAG]`** What was tried first (the plan) → **why it failed or fell short** → **what was the next iteration** (or current direction).

Use the **cheat sheet** for each note:

- **What was the plan?** (e.g. “Use standard Stripe webhooks”.)
- **Why did it fail or fall short?** (e.g. “Race conditions under high concurrency”.)
- **What was the next iteration?** (e.g. “Redis-based queue to serialize events”.)
- **Who helped?** (if the user mentioned someone, e.g. “Worked with @DevName to …”.)

If the user wrote notes like “I tried X but it didn’t work because Y”, use that for “plan” and “why it failed”, and infer or ask for “next iteration” if missing.

**Principle:** If the first approach worked with no iteration, it’s ordinary work—no SR&ED note needed (or say “Routine implementation; no technical uncertainty.”). Only document items where there was a second (or third) attempt or a clear technical uncertainty.

## 5. Output format

Produce the notes in this structure so the user can paste into their SR&ED documentation:

```markdown
## SR&ED Notes — [Branch name or ticket]

### 1. [Scenario name]

- **Tag:** [FEATURE] | [BUG] | [SPIKE] | [INFRA]
- **Weak note (avoid):** …
- **SR&ED note:** [TAG] …
- **Cheat sheet:** Plan: … | Why it failed: … | Next iteration: … | Who helped: …
```

Repeat for each distinct work item. End with a short reminder: “If the first thing you tried worked perfectly, it’s just work; if you had to try a second or third way, it’s SR&ED.”
