---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

- Based on the above changes, create a single git commit with properly commit message. 
- Review the file diffs from the last commit to HEAD, figure out what's been changed, and write a clear, concise commit message. Make sure the commit message is in English.
- The tasks you need to do are `git add .` and `git commit`. You must not run `git push` and `git pull` because running these commands are my task.
- Do not write a message like a `🤖 Generated with [Claude Code](https://claude.ai/code)`. We do not need to say that this commit was created by gen AI.
- List files that are added by `git add .` command. Here is the sample.
```md
- src/App.tsx
- src/components/Item.tsx
```
