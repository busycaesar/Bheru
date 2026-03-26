---
description: Generate PR title and description from branch diff, then create PR on GitHub (with confirmation)
alwaysApply: false
---

# Create PR (title, description, then gh pr create)

When the user invokes this rule (e.g. by @ mentioning this file), follow these steps in order. Do not skip any step.

### Default PR reviewers (always)

On every `gh pr create`, include these reviewers (GitHub logins):

- `Ramon-Lobo`
- `ParamountPaiva`

If the user names **additional** reviewers when confirming, append more `--reviewer <login>` flags. Do not omit the default two.

---

## Step 1: Generate PR title and description

### 1.1 Get the diff

Run in the repo root:

```bash
git diff origin/main..HEAD
```

Also get the current branch name:

```bash
git branch --show-current
```

### 1.2 Analyze the diff

From the diff output, identify:

- Which files were modified (list each file path)
- What was added, fixed, or changed (describe each change)
- Which components/areas were affected
- Scope and impact of the changes

### 1.3 Extract ticket key from branch name

From the current branch name, extract the ticket key if present (e.g. `fix/TWOAPP-1332/recruiting-urls` → `TWOAPP-1332`). Use a pattern like `[A-Z]+-\d+`. If none is found, no ticket suffix is added.

### 1.4 Generate title

Follow the requirements below (same as in `.gemini/commands/pr.toml`):

- **Format:** `<type>(<scope>): <description> #<TICKET>`
- **Type:** exactly one of: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **Scope:** optional; reflects the main area of change
- **Description:** lowercase, present tense, no period at end, clear and concise
- **Length:** entire title 72 characters or less
- **Ticket:** append ` #<TICKET>` at the end (e.g. `#TWOAPP-1332`) only if you extracted a ticket key in 1.3; otherwise omit.

### 1.5 Generate description (body)

Use this **exact structure** for the PR body (markdown):

```
### Comments/Description:

- [First line: user-facing improvement or purpose; include previous behavior if relevant.]
- [Second line: technical implementation (files, components, tests).]

### Screenshots:

[Leave empty — no content between this header and the next section.]

### Addresses issue(s):

- https://paramount.atlassian.net/browse/[TICKET]
```

- **Comments/Description:** Exactly two bullet points. Use `-` (hyphen) for list markers. Keep each to 1–2 lines. Format file paths, variable names, and component/function names in **backticks** (e.g. `src/constants/index.ts`, `landingPageUrlWomenBasketball`).
- **Screenshots:** Leave this section empty (no placeholder text).
- **Addresses issue(s):** One bullet with the JIRA URL. Replace `[TICKET]` with the ticket key extracted in 1.3 (e.g. `TWOAPP-1332` → `https://paramount.atlassian.net/browse/TWOAPP-1332`). If no ticket key was found, omit the "Addresses issue(s)" section entirely.

### 1.6 Determine label

Based primarily on the **diff content** from 1.2, choose exactly one label:

- **`bug`** — the diff corrects broken, incorrect, or unintended behavior: e.g. wrong conditional, misplaced element, off-by-one, incorrect data being shown/hidden, crash fix, or any change whose purpose is to make something work as originally intended.
- **`enhancement`** — the diff adds new functionality, extends an existing feature, improves UX, refactors code, or adds/updates tests without fixing broken behavior.

Use the branch name and commit type only as a **tiebreaker** when the diff alone is ambiguous (`fix/` branch / `fix` type → lean `bug`; `feat/` branch / `feat` type → lean `enhancement`). The code change takes priority over the branch name.

### 1.7 Show title, description, and label to the user

Output the generated **title**, **description**, and **label** clearly, and ask:

**"Confirm to create the PR with the above title, description, and label (y/n), or say what to change."**

Always pass the **default reviewers** (`Ramon-Lobo`, `ParamountPaiva`) on `gh pr create`. If the user names **extra** reviewers when confirming, add `--reviewer` for each additional login.

Do not run `gh pr create` until the user confirms.

---

## Step 2: Create the PR on GitHub (after confirmation)

Only after the user confirms (e.g. "y", "yes", "create it", "looks good"):

1. Create the PR with the current branch as the head and `origin/main` as the base.
2. Run in the repo root. **Always** include `--reviewer Ramon-Lobo --reviewer ParamountPaiva` and `--label <label>` (either `bug` or `enhancement`). Add more `--reviewer <login>` flags for any extra reviewers the user named when confirming.

   ```bash
   gh pr create --base main --title "<generated title>" --body "<generated description>" --assignee busycaesar --reviewer Ramon-Lobo --reviewer ParamountPaiva --label "<label>"
   ```

   Use the exact title, description, and label that the user approved. Assign the PR to **busycaesar** with `--assignee busycaesar`. If `gh` errors with _you must first push_ or wrong head, add `--head <branch-name>` (e.g. `--head fix/TWOAPP-430/feature-name`) so the remote branch is explicit.

   If the description contains double quotes or newlines, write the body to `.pr-body-temp.md` in the repo root and use:

   ```bash
   gh pr create --base main --title "..." --body-file .pr-body-temp.md --assignee busycaesar --reviewer Ramon-Lobo --reviewer ParamountPaiva --label "<label>"
   ```

3. After the PR is created successfully, delete the temporary body file if one was used: remove `.pr-body-temp.md` from the repo root (so it does not appear in `git status`).

4. Report the result: success (with PR URL if `gh` outputs it) or the error message from `gh`.

If the user asks for edits (e.g. "change the title to ..." or "add X to the description" or "change the label"), update accordingly, show the new version, and ask for confirmation again before running `gh pr create`.
