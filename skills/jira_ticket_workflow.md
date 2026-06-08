---
alwaysApply: false
---
# JIRA Ticket Implementation Workflow

When the user provides a JIRA ticket description (pasted in the chat), follow the four sub-workflows below **in order**. Each step references a dedicated rule file — read and follow that file fully before moving to the next step.

---

## Step 1 — Spec, ambiguity removal, and checklist

Follow **`@spec.mdc`** in full.

Output: a saved spec file with confirmed assumptions and a verification checklist mapping every acceptance criterion to specific file paths in the codebase.

Do not proceed until the spec is finalised and the checklist is saved.

---

## Step 2 — Plan

Follow **`@plan.mdc`** in full.

Input: the final spec and verification checklist from Step 1.
Output: a saved, ordered step list where every step references exact file paths and has a clear acceptance condition.

Do not proceed until the full plan is written and saved.

---

## Step 3 — Implement

Follow **`@implement.mdc`** in full.

Input: the ordered step list from Step 2.
Output: all steps executed, each acceptance condition met, progress log maintained.

Do not proceed until every step in the plan is complete.

---

## Step 4 — Verify

Follow **`@verify.mdc`** in full.

Input: the verification checklist from Step 1 and the implementation from Step 3.
Output: every checklist item confirmed satisfied; any gaps fixed and re-verified; final report to the user.

---

## Summary

| Step | Rule file | Action |
| ---- | --------- | ------ |
| 1 | `spec.mdc` | Parse ticket → draft spec → confirm all assumptions → create checklist with file paths. |
| 2 | `plan.mdc` | Ground plan in codebase → write ordered, file-specific steps with acceptance conditions. |
| 3 | `implement.mdc` | Execute each step → confirm acceptance gate → log progress and deviations. |
| 4 | `verify.mdc` | Measure every checklist item → fix all gaps → confirm no regressions → report to user. |

**Important:** Complete each step fully before starting the next. Do not mark the ticket done until Step 4 reports all checklist items satisfied.
