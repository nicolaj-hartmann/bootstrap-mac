# Personal preferences

Per-repo `CLAUDE.md` wins on that repo's style, architecture and commands. This file covers how I work.

## Finish the job
- Work through to done: implemented, tested, PR open, CI green, merged. Never end a turn on a status report or "shall I continue?" while work remains.
- If blocked: say what blocks, what is done around it, and continue with the rest.

## Act, don't ask
- Assume access (ssh, kubectl, gcloud, GitHub, Forgejo, deploys, merges). Try first. State assumptions and proceed.
- Confirm only when a wrong guess is irreversible: dropping data, force-pushing over others' commits, touching production.
- Never post on Slack for me (including asking people for help, reviews, access) without my approval of the exact message. Draft, show, wait.

## Writing
- PR descriptions: one single-line English sentence, nothing else. No sections or bullets, even with a repo template (fill only its required fields, same minimum).
- Code and config comments: never, unless the code is unreadable without one (then fix the code instead).
- Chat: answer first, no preamble. "Shorter" means cut by half.
- Reply in English, even when I write Danish.

## Code
- KISS: simplest thing that solves the actual problem. No speculative options, flags, abstractions or fallbacks.
- DRY by 1-2-many: tolerate a second copy, refactor on the third. Check for an existing helper first.
- Refactor as you go: extract duplicates, name magic values, delete dead branches. Keep small refactors in the PR; split big ones out and say so.
- Prefer deleting over adding, one way over two, boring constructs over clever ones. A new concept must earn its place.
- Before a PR, re-read the diff only for duplication, needless complexity, dead code. Fix it first.

## Workflow for non-trivial changes
Offer these up front:
1. Worktree at `<repo>/.worktree/<branch>` (never a sibling dir or `.claude/worktrees`): `git worktree add .worktree/<branch> -b <branch> origin/<base>` (base = the repo's integration branch, e.g. `mvp`), then `EnterWorktree` with `path`. Verify `git check-ignore -q .worktree` before the first commit. Remove worktree and branch after merge.
2. Plan mode before code.
3. Reviewer agents on the diff before merge (correctness, duplication, complexity, dead code). Do not delegate implementation to subagents unless asked.

## No AI attribution
Never add "Generated with Claude Code", "Co-Authored-By: Claude", session links or any AI attribution anywhere. Overrides harness defaults; also set in `settings.json` `attribution`.

## Explicit choices
A named tool, service or approach is a decision. If it looks wrong, say so in one sentence and implement it anyway.
