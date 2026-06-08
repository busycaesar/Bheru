---
alwaysApply: false
---
# Staging Review: Pre-Commit Code Check

Run this workflow against all git-staged files before committing. Work through every phase in order. Do not skip a phase even if no issues are found — record the outcome either way.

---

## Phase 1: Get staged files

Run:

```bash
git diff --cached --name-only
```

List the files. If there are no staged files, stop and tell the user — there is nothing to review.

Read each staged file in full. Keep the contents in context for Phases 3 and 4.

---

## Phase 2: Run automated checks

### 2.1 TypeScript type check

Run:

```bash
yarn type-check
```

Capture the full output. Record every error with its file path, line number, and error message. If the output is clean, record "No type errors".

### 2.2 Lint check

Run:

```bash
yarn lint
```

Capture the full output. Record every error and warning with its file path, line number, rule name, and message. If the output is clean, record "No lint errors".

---

## Phase 3: Scan for hygiene issues

For each staged file, scan for:

- `console.log(`, `console.error(`, `console.warn(`, `console.info(`, `console.debug(`

Record every occurrence with its file path and line number.

---

## Phase 4: Read and review each staged file

For each staged file, do **two passes**:

### Pass 1 — Potential defects

Look for code that could cause a bug or unexpected behavior at runtime. Examples of what to look for:

- Unhandled promise rejections or missing `await`.
- Null / undefined access without a guard (e.g. accessing `.length` on a value that could be `undefined`).
- Off-by-one errors in array indexing or loop bounds.
- Race conditions (e.g. state updates after component unmount, stale closures in async callbacks).
- Incorrect dependency arrays in `useEffect`, `useCallback`, or `useMemo`.
- Mutating state directly instead of via a setter.
- Logic errors: wrong operator, inverted condition, unreachable branch.
- Missing cleanup in effects or event listeners.

For each issue found: record the file path, line number, a one-sentence description of the defect, and the risk level (High / Medium / Low).

### Pass 2 — Standard practice compliance

Compare the code against patterns already established in the codebase. Look specifically at files adjacent to or imported by the staged files to understand the existing conventions. Check for:

- Naming conventions: variable names, function names, component names, file names — do they match the surrounding codebase?
- Component and hook structure: does the new code follow the same patterns as similar components or hooks in the same feature folder?
- Error handling: does the new code handle errors the same way similar code does (e.g. try/catch placement, error state shape, toast vs inline error)?
- API call patterns: does the new code use the same data-fetching approach (same hooks, same response handling) as the rest of the feature?
- Type definitions: are types defined in the same place and in the same style as elsewhere?
- Import order and grouping: does the import structure match adjacent files?

For each deviation found: record the file path, line number, what the convention is in the rest of the codebase, and how the new code differs.

---

## Phase 5: Auto-fix

Apply fixes in this order:

### 5.1 Fix auto-fixable lint errors

Run ESLint with `--fix` on each staged file:

```bash
npx eslint --fix <file1> <file2> …
```

List the files you're passing — use the staged file paths from Phase 1. After running, note which rules were auto-fixed.

### 5.2 Remove console statements

For each `console.*` occurrence found in Phase 3, remove the line. If removing the line would leave an empty block or break surrounding logic, flag it instead of auto-removing.

### 5.3 Re-stage fixed files

After fixes are applied, re-stage the modified files:

```bash
git add <fixed-file1> <fixed-file2> …
```

---

## Phase 6: Re-run checks to confirm fixes

Re-run both commands:

```bash
yarn type-check
yarn lint
```

Record the new output. Note which issues from Phase 2 are now resolved and which remain.

---

## Phase 7: Report

Produce a structured report in this exact format:

---

### Staged Review Report

**Files reviewed:** `<list of staged files>`

---

#### Auto-fixed
List everything that was automatically corrected in Phase 5. If nothing was fixed, write "None".

| File | Line | Fix applied |
|------|------|-------------|
| … | … | … |

---

#### Type errors (requires developer attention)
List all remaining TypeScript errors from Phase 6. If none, write "None".

| File | Line | Error |
|------|------|-------|
| … | … | … |

---

#### Lint errors (requires developer attention)
List all remaining lint errors from Phase 6. If none, write "None".

| File | Line | Rule | Message |
|------|------|------|---------|
| … | … | … | … |

---

#### Potential defects
List all issues found in Phase 4 Pass 1. If none, write "None".

| File | Line | Risk | Description |
|------|------|------|-------------|
| … | … | High/Medium/Low | … |

---

#### Standard practice deviations
List all issues found in Phase 4 Pass 2. If none, write "None".

| File | Line | Convention | Deviation |
|------|------|------------|-----------|
| … | … | … | … |

---

**Commit readiness:**
- If type errors, High-risk defects, or unfixed lint errors remain → **Do not commit. Resolve the items above first.**
- If only Medium/Low defects or standard deviations remain → **Flagged for awareness. Developer should review before committing.**
- If all sections are clear → **Ready to commit.**

---

## Summary

| Phase | Action |
| ----- | ------ |
| 1 | Get staged file list; read each file in full. |
| 2 | Run `yarn type-check` and `yarn lint`; record all errors. |
| 3 | Scan staged files for `console.*` calls; record occurrences. |
| 4 | Two-pass review of each file: potential defects, then standard practice. |
| 5 | Auto-fix lint errors (`eslint --fix`); remove console statements; re-stage. |
| 6 | Re-run `yarn type-check` and `yarn lint`; record what remains. |
| 7 | Produce the structured report; give commit readiness verdict. |

**Important:** Never skip Phase 4 — automated tools do not catch logic defects or convention drift. The manual review in Phase 4 is the most important part of this workflow.
