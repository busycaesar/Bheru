---
description: Generate a conventional-commit message from staged and branch changes — outputs text only, never commits
alwaysApply: false
---

# Generate Commit Message

Output **only** the commit message string. No explanation, no preamble, no trailing commentary.

## Step 1: Gather the diff

Run both commands from the repo root:

```bash
git diff --staged
```

```bash
git diff origin/main..HEAD
```

Use both together. Staged changes take priority (they are what would be committed). If nothing is staged, use the branch diff.

Also get the current branch name:

```bash
git branch --show-current
```

## Step 2: Determine type and scope

Choose **exactly one** type:

| Type       | When                                                     |
| ---------- | -------------------------------------------------------- |
| `feat`     | New functionality visible to users                       |
| `fix`      | Corrects broken or incorrect behavior                    |
| `refactor` | Code restructuring with no behavior change               |
| `test`     | Adding or updating tests only                            |
| `chore`    | Tooling, config, dependencies, build                     |
| `docs`     | Documentation only                                       |
| `style`    | Formatting, whitespace, no logic change                  |

Scope is the affected area in lowercase (e.g. `community`, `recruiting`, `auth`). Omit scope only if the change is truly cross-cutting.

## Step 3: Write the message

Format:

```
<type>(<scope>): <description>
```

Rules:
- Description: lowercase, present tense, no period, ≤ 72 chars total for the first line
- If the change warrants a body (e.g. non-obvious motivation or breaking change), add a blank line then 1–2 sentences. Keep it tight.

## Step 4: Output

Return **only** the commit message — first line, optional blank line, optional body. Nothing else.
