---
description: Handle a code review comment from a team member — analyse intent, assess validity, then either implement the change or draft a reviewer reply
alwaysApply: false
---

# Code Review Handler

When the user pastes a code review comment (along with the relevant code snippet or diff it refers to), follow this workflow **in order**. Do not skip phases.

---

## Phase 1: Gather full context

### 1.1 Read the review input

The user will provide:

- The **review comment** text from the team member.
- The **code snippet or diff** the comment refers to.

Read both carefully before doing anything else.

### 1.2 Get the branch diff

Run in the repo root to understand the full scope of changes made on this branch:

```bash
git diff origin/main..HEAD
```

Use this diff to infer the **developer's intent** — what they were trying to achieve with each change, which areas they deliberately modified, and what the overall goal of the PR is.

---

## Phase 2: Analyse the review

Work through the following four checks in order. Document your findings for each one before moving to the decision in Phase 3.

### Check 1 — Technical validity

Is the reviewer's suggestion technically sound and correct?

- Would their proposed change actually work as intended?
- Is the suggestion based on a correct understanding of the code, or does it appear to misread what the current code does?

### Check 2 — Intentionality of the original change

Was the code the reviewer is opposing **intentionally written that way** by the developer?

- Use the `git diff` from Phase 1 to infer intent. Look at the surrounding context, the pattern of changes, and whether the code aligns with what the rest of the PR is doing.
- The question to answer: did the developer **deliberately** write it this way, or does it look like a mistake or oversight?

### Check 3 — Scope of impact

Which parts of the codebase would be affected if the reviewer's suggestion were implemented?

- List the specific files, components, hooks, or flows that would change.
- Identify any downstream effects (other callers, shared utilities, state flows, etc.).

### Check 4 — Clean code and consistency

Would implementing the suggestion break anything or go against the project's existing coding conventions?

- Compare the suggested approach against how similar things are done elsewhere in the codebase.
- Check for: naming consistency, separation of concerns, component/hook patterns, error handling style, and any patterns that would be introduced or removed.

---

## Phase 3: Decide — implement or reply

Based on the four checks, make one of two decisions:

---

### Path A — Implement the change

**When to take this path:**
All of the following are true:

- The reviewer's suggestion is technically valid (Check 1).
- The original change does not appear to have been made for a deliberate, well-reasoned purpose that the reviewer has missed (Check 2).
- The impact is understood and manageable (Check 3).
- The suggestion aligns with or improves the project's coding conventions (Check 4).

**What to do:**
Treat the reviewer's suggestion as the requirement and follow the full **`@jira-ticket-workflow.mdc`** workflow:

- Phase 1: Create a spec from the review comment. Clarify anything ambiguous before proceeding.
- Phase 2: Remove all ambiguity from the spec.
- Phase 3: Map the spec to the codebase and create a verification checklist with specific file paths.
- Phase 4: Plan steps with exact file paths and implement via sub-agents.
- Phase 5: Verify against the checklist; fix until all items pass.
- Phase 6: Create or update unit tests for all changed code.
- Phase 7: Run `yarn test`; fix until all tests pass.

---

### Path B — Draft a reviewer reply

**When to take this path:**
Any of the following are true:

- The suggestion is not technically sound or is based on a misreading of the code.
- The original change was clearly intentional and made for a specific, defensible reason.
- Implementing it would break existing behaviour or introduce inconsistency with the rest of the codebase.
- The suggestion is a stylistic preference that does not materially improve correctness, maintainability, or clarity.

**What to do:**
Produce two outputs:

1. **Reply for the reviewer** (copy-paste ready):
   A 2–3 sentence response written in a respectful, collaborative tone. It must cover:
   - Why the code is written the way it is.
   - What specific challenge, constraint, or deliberate design decision led to that implementation.
   - (If applicable) What trade-off was accepted and why.

   Keep it factual and direct — no defensive language, no filler.

2. **Explanation for the developer**:
   A brief internal note (3–5 sentences) explaining:
   - Which of the four checks caused the decision not to implement.
   - What evidence from the diff or codebase supports keeping the code as-is.
   - Any action the developer may want to take (e.g. add a code comment, raise a follow-up ticket, discuss further in the PR thread).

---

## Summary

| Phase | Action                                                                                                 |
| ----- | ------------------------------------------------------------------------------------------------------ |
| 1     | Read review comment + code context; run `git diff origin/main..HEAD` to understand developer intent.   |
| 2     | Run all four checks: technical validity, intentionality, scope of impact, clean code consistency.      |
| 3A    | If the review is valid → follow `jira-ticket-workflow.mdc` in full (spec → implement → verify → test). |
| 3B    | If the review is not well-founded → produce a reviewer reply (2–3 sentences) + developer explanation.  |

**Important:** Always complete all four checks in Phase 2 before deciding. Never skip to the decision early.
