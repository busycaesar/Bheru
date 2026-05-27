---
description: Update unit tests from git diff (main..HEAD)
globs: '**/*.test.{ts,tsx}'
alwaysApply: false
---

# Update tests from branch changes

When asked to add or update unit tests based on recent code changes, follow this workflow:

## 1. Get the diff

Run in the repo root:

```bash
git diff origin/main..HEAD
```

Use this to see all changes on the current branch vs `main`. If your base branch is different (e.g. `develop`), use that instead.

## 2. Map changes to test files

- **Source files** live under `src/` (e.g. `src/features/recruiting/components/RecruitingTabView.tsx`).
- **Test files** live in a `__tests__` folder next to the source or in the same feature (e.g. `src/features/recruiting/components/__tests__/RecruitingTabView.test.tsx`).
- For each modified or new source file, find or create the corresponding test file: same path, with `__tests__/` and `*.test.ts` or `*.test.tsx`.

## 3. Add or update tests

- **New code paths / exports**: Add tests that cover the new behavior (props, hooks, handlers, edge cases).
- **Changed logic**: Update or add tests so they match the new behavior; fix or remove tests that asserted old behavior.
- **Deleted code**: Remove or adjust tests that targeted the removed code.
- Follow existing test style in the file (e.g. `describe`/`it`, React Testing Library, mocked modules).
- **Coverage requirement**: Every line that was changed or added must have a unit test. Only leave lines or files untested when they genuinely cannot be tested (e.g. platform-specific code, third-party integration boundaries, or code that is not meaningfully testable in isolation).

## 4. Run tests and check coverage

After adding or updating tests:

1. Run the full suite to confirm nothing is broken: `yarn test`.
2. Run coverage: `yarn test:coverage`.

**Coverage target**: Coverage for the changed/added code (and for the affected files) should be between **90–100%**. If coverage falls below 90%, add or adjust tests until it meets this range. Only leave coverage below 90% for lines or files that cannot reasonably be tested (document the reason if needed).
