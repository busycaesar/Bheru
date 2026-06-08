---
alwaysApply: false
---
# Specification: Create, Refine, and Checklist

Follow these three phases **in order** before any code is written. Do not skip phases or assume answers — ask the user whenever something is unclear or implied.

---

## Phase 1: Create specification (with clarifications)

1. **Parse the ticket**
   Read the full JIRA description (title, description, acceptance criteria, links, comments if any).

2. **Draft a specification**
   Create a structured spec that captures:
   - **Goal** – What the ticket is trying to achieve.
   - **Scope** – In scope vs out of scope.
   - **User/actor** – Who is affected (e.g. recruiter, candidate, admin).
   - **Behavior** – Desired behavior, flows, and edge cases.
   - **APIs / data** – Endpoints, payloads, or data changes if mentioned.
   - **UI** – Screens, components, or copy changes if applicable.

3. **Ask for all clarifications**
   For anything **ambiguous, missing, or implied** in the ticket, list questions and **wait for the user's answers** before continuing. Examples:
   - Unclear acceptance criteria
   - Missing error handling or empty states
   - Conflicting or vague wording
   - Assumed tech choices (e.g. which API, which component)
   - Priority when multiple interpretations exist

4. **Write the spec**
   Save the spec to a file (e.g. `docs/specs/<ticket-key>-spec.md` or a path the user prefers). Include the ticket key and a short title in the filename.

---

## Phase 2: Remove ambiguity from the spec

1. **Review the spec line by line**
   For every statement that is **assumed**, **implicit**, or could be read in more than one way, flag it.

2. **Confirm with the user**
   For each flagged item, state the assumption and ask: "Is this correct?" or "Should it be X or Y?"
   Do not proceed until even "tiny" assumptions are confirmed. Examples:
   - "We assume the button is only visible to users with role X — correct?"
   - "Empty list shows message 'No items' — confirm?"
   - "On network error we show a toast and keep the form — confirm?"

3. **Update the spec**
   Incorporate the user's answers into the spec and mark it as the **final version**. Add a short "Assumptions confirmed" section at the end listing every confirmed assumption.

---

## Phase 3: Create the verification checklist

1. **Map the spec to the codebase**
   Explore the codebase to identify the specific files and areas that will be affected. Search for relevant components, hooks, API clients, routes, or modules by feature name, screen name, or behavior from the spec. Keep in mind:
   - Where the behavior or UI lives (which feature folder, which component).
   - Which files will need to change for each part of the spec.
   - Existing patterns (e.g. where similar behavior is implemented).

2. **Derive a checklist from the final spec (codebase-aware)**
   Each acceptance criterion and confirmed behavior becomes at least one checklist item. For each item, note the specific file(s) where the change will be implemented or verified. Format:

   ```markdown
   ## Verification checklist (for [TICKET-KEY])

   **Files affected:**

   - `src/features/…/Component.tsx` – …
   - `src/…/hook.ts` – …

   - [ ] Item 1 — _Recruiter sees new 'Archive' button on the row_ → `src/features/recruiting/…/RecruitingRow.tsx`
   - [ ] Item 2 — _Clicking Archive calls POST /api/archive with id_ → `src/…/useArchiveJob.ts`, `src/…/api.ts`
   - [ ] Item 3 — _Success shows toast and row is removed from list_ → `…/RecruitingRow.tsx`, `…/RecruitingList.tsx`
   ```

3. **Save the checklist**
   Append it to the spec file or save to a separate file (e.g. `docs/specs/<ticket-key>-checklist.md`). The file references ensure verification is done against the right places in the codebase.

---

## Summary

| Phase | Action |
| ----- | ------ |
| 1 | Parse ticket; draft spec; ask every clarification; save spec file. |
| 2 | Flag every assumption; confirm each with the user; update final spec. |
| 3 | Map spec to codebase; derive checklist with specific file(s) per item; save it. |

**Important:** Do not proceed past Phase 1 until all clarifications are answered. Do not proceed past Phase 2 until every assumption is confirmed.
