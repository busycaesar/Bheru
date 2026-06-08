---
alwaysApply: false
---
# Verification: Confirm Every Checklist Item Passes

This phase takes the verification checklist from `spec.mdc` and measures the implemented code against every item. Do not mark the ticket complete until all items pass.

---

## Phase 1: Re-read the checklist

Open the checklist file saved during spec creation (e.g. `docs/specs/<ticket-key>-checklist.md`). Read every item before starting any verification — understand the full scope before measuring anything.

---

## Phase 2: Measure each checklist item

For each item in the checklist:

1. **Locate the file(s) listed for that item.**
   Open and read the relevant sections of each file.

2. **Verify the behavior described in the item.**
   Methods (use whichever applies):
   - Read the code and trace the logic — confirm the behavior is implemented as the spec requires.
   - Check that new UI elements are rendered and wired to the correct handlers.
   - Confirm API calls use the correct endpoint, method, and payload.
   - Verify error and empty states are handled as confirmed in the spec.

3. **Mark the item as satisfied or flag it as a gap.**

   ```
   [✓] Item 1 — Recruiter sees new 'Archive' button → confirmed in RecruitingRow.tsx line 42
   [✗] Item 2 — Clicking Archive calls POST /api/archive — handler is wired but endpoint path is wrong
   ```

---

## Phase 3: Fix all gaps

For every item marked as a gap:

1. Identify the root cause (missing code, wrong behavior, wrong file edited).
2. Fix the implementation — treat each gap as a new, scoped task with the same acceptance gate used in `implement.mdc`.
3. After fixing, re-verify the item before moving on.
4. Once fixed, update its status in the checklist:

   ```
   [✓] Item 2 — fixed: corrected endpoint path in api/jobs.ts
   ```

Repeat until every item in the checklist is marked satisfied.

---

## Phase 4: Final confirmation

When all items are marked satisfied:

1. Do a final pass over the checklist — no items left as gaps.
2. Confirm no regressions: briefly review the files that were changed to ensure nothing was inadvertently broken outside the scope of the ticket.
3. Report to the user: list every checklist item with its satisfied status and note any deviations from the original plan.

---

## Summary

| Phase | Action |
| ----- | ------ |
| 1 | Re-read the full checklist before starting. |
| 2 | Measure each item against the implementation; mark satisfied or gap. |
| 3 | Fix every gap; re-verify after each fix. |
| 4 | Final pass to confirm all items satisfied and no regressions; report to user. |

**Important:** Do not report the ticket as complete until every checklist item is marked satisfied.
