# SDLC Skills

<p align="center">
  <img width="800" alt="Banner" src="https://github.com/user-attachments/assets/61d1c02c-9694-4441-a3fa-74b536e4e194" />
</p>

## Description

This repo is a curated set of custom skills (`.mdc` files) that cover the full software development lifecycle — from writing a spec and breaking work into a plan, to executing implementation via sub-agents, running code reviews, writing tests, and creating pull requests. Each skill is a structured prompt that guides Claude through a specific workflow phase with clear inputs, outputs, and acceptance criteria.

The skills are designed to work together as a pipeline: `spec.mdc` defines the work, `plan.mdc` grounds it in the codebase, `implement.mdc` executes it step by step, and `verify.mdc` confirms everything passes before the ticket is closed. Supporting skills like `code-review.mdc`, `unit_tests.mdc`, `pr-create.mdc`, and `jira-ticket-workflow.mdc` handle the surrounding dev process.

## Tech Stack

![Image Alt](https://skillicons.dev/icons?i=md)

## How it looks?

## Features

- **End-to-end SDLC prompts** — Each `.mdc` file is a Cursor rule: structured instructions for one phase of development (spec, planning, implementation, verification, PRs, reviews, tests).
- **Composable pipeline** — Core flow aligns as `spec.mdc` → `plan.mdc` → `implement.mdc` → `verify.mdc`. `jira-ticket-workflow.mdc` wires these (and related rules) into a single ordered workflow when you work from a JIRA ticket.
- **Quality and delivery** — Supporting rules include code review (`code-review.mdc`), unit tests (`unit_tests.mdc`), test prompts (`tests-prompt.mdc`), staging review (`staging-review.mdc`), address review feedback (`address_reviews.mdc`), and PR creation (`pr-create.mdc`).
- **Extras** — `sred_notes.mdc` drafts SR&ED-style notes from branch diffs. `implement-1.mdc` is a duplicate of `implement.mdc` (same content); use one copy in `.cursor/rules/` unless you intentionally want two rule entries.
- **Cursor-native** — Rules use Markdown with optional YAML frontmatter (`alwaysApply`, `globs`, `description`) so you can scope when each rule applies in Cursor.

## How to run the project?

This repository does **not** ship an application server, CLI, or build step. **“Running” it means installing the rules into Cursor** so the agent can follow them in your workspace.

1. **Put rules where Cursor loads them** — Copy or symlink the `.mdc` files from this repo into **`.cursor/rules/`** in the project where you want these workflows (the codebase you are building or maintaining). Cursor reads rules from that folder, not from arbitrary paths elsewhere on disk.
2. **Choose what to install** — You can copy the full set or only the rules you need (for example, only `spec.mdc` and `plan.mdc`). File names stay as `*.mdc`.
3. **Tune frontmatter (optional)** — Edit each rule’s YAML header if you want a rule to always apply (`alwaysApply: true`), apply only when certain files are open (`globs`), or show a clearer label in the rule UI (`description`).
4. **Use the project in Cursor** — Open the target project in Cursor. Reference rules in chat with `@` and the rule name, or rely on automatic inclusion when globs/`alwaysApply` match.

If you clone this repo only to browse or version the rules, still place copies (or symlinks) under **that** workspace’s `.cursor/rules/` if you want Cursor to apply them while working inside this repo.

## Author

[Dev J. Shah](https://github.com/busycaesar)
