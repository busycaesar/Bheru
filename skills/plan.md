---
alwaysApply: false
---
# Planning: Break Work into Ordered, File-Specific Steps

This phase takes the final spec and verification checklist (from `spec.mdc`) and produces a concrete, ordered implementation plan grounded in the actual codebase. No code is written here — the output is a plan ready to hand to `implement.mdc`.

---

## Phase 1: Ground the plan in the codebase

Using the **files affected** listed in the verification checklist, re-examine the codebase so every step targets real paths, not generic names.

1. **Open the key files**
   Read the relevant components, hooks, API clients, and modules identified in the checklist. Understand their current shape before deciding what to change.

2. **Check imports and call sites**
   For each affected file, trace who imports it and what calls it. This determines the correct order for changes (e.g. create a hook before wiring it into a component).

3. **Identify where new files belong**
   If new files are needed (a new hook, a new component, a new API function), decide exactly where they go — same feature folder, next to the closest existing equivalent.

4. **Note dependencies between steps**
   Flag any step that depends on the output of a previous step so the implementation order is correct.

---

## Phase 2: Break the work into ordered, file-specific steps

List concrete, executable steps. **Each step must:**
- Reference the specific file(s) where changes are made (full paths).
- Be small enough for a single sub-agent or a single edit session.
- State its acceptance condition (what "done" looks like for that step).

**Format:**

```
Step 1 — <short description>
  File(s): src/features/…/Component.tsx
  Done when: <acceptance condition tied to the spec/checklist>

Step 2 — <short description>
  File(s): src/features/…/hooks/useArchiveJob.ts (new), src/features/…/api/jobs.ts
  Done when: <acceptance condition>

Step 3 — <short description>
  File(s): src/features/…/Component.tsx
  Depends on: Step 2
  Done when: <acceptance condition>
```

**Rules:**
- Steps must be ordered so that no step depends on work that hasn't been done yet.
- A step that creates a new file must come before any step that imports it.
- Each step maps to one or more checklist items from the verification checklist — note which ones.

---

## Phase 3: Save the plan

Save the ordered step list to a file (e.g. `docs/specs/<ticket-key>-plan.md`) or append it to the existing spec file. This plan is the input to `implement.mdc`.

---

## Summary

| Phase | Action |
| ----- | ------ |
| 1 | Open affected files; trace imports and call sites; identify where new files belong; note step dependencies. |
| 2 | Write ordered, file-specific steps with acceptance conditions; map each step to checklist items. |
| 3 | Save the plan. |

**Important:** Every step must reference exact file paths from the codebase. Do not proceed to implementation until the full ordered plan is written and saved.
