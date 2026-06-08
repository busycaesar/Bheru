---
alwaysApply: false
---
# Implementation: Execute the Plan via Sub-Agents

This phase takes the ordered step list from `plan.mdc` and executes each step. Work through the steps in order — do not start a step until the previous one is complete and consistent with the spec.

---

## Phase 1: Execute each step

For every step in the plan:

1. **Launch a sub-agent (or perform the edit directly)**
   - Use the **Task tool** (or equivalent) to run a sub-agent for any step that is non-trivial or touches multiple files.
   - For a single, tightly scoped change, perform the edit directly.

2. **Sub-agent task description must include:**
   - The exact step to perform (from the plan).
   - The **full path(s) of the file(s) to change**.
   - The acceptance condition for that step (from the plan).
   - Any context the sub-agent needs (e.g. relevant type definitions, existing patterns to follow).

3. **Acceptance gate**
   Before moving to the next step, confirm the current step's acceptance condition is met:
   - The change compiles without errors.
   - The behavior matches what the spec and checklist require for that step.
   - No regressions introduced in files that were not supposed to change.

---

## Phase 2: Track progress

Maintain a running log as you work through the steps. For each completed step, record:

```
[DONE] Step 1 — <description>
  Files changed: src/features/…/Component.tsx
  Notes: <any deviation from the plan, or "as planned">

[DONE] Step 2 — <description>
  Files changed: src/features/…/hooks/useArchiveJob.ts (created), src/features/…/api/jobs.ts
  Notes: as planned

[IN PROGRESS] Step 3 — …
```

If a step reveals that the plan needs to change (e.g. a file was in a different location, or a dependency was missing), update the plan and note the deviation before continuing.

---

## Phase 3: Handle deviations

If a step cannot be completed as planned:

1. Stop and diagnose — do not proceed to the next step.
2. Determine whether the deviation is:
   - A **plan error** (wrong file path, missing dependency) → update the plan and re-execute the affected step.
   - A **spec gap** (behavior is unclear for this case) → surface the question to the user and wait for an answer before continuing.
3. Document the resolution in the progress log.

---

## Summary

| Phase | Action |
| ----- | ------ |
| 1 | Execute each step via sub-agent or direct edit; confirm acceptance condition before moving on. |
| 2 | Log completed steps with files changed and any deviations. |
| 3 | On deviation: diagnose, fix the plan or surface spec gap, then continue. |

**Important:** Never skip the acceptance gate between steps. If a step's output is wrong, fix it before starting the next one.
