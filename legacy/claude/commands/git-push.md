---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Recent commits: !`git log --oneline`

## Your task
- Push my changes by running `git push`
- You must confirm the list of commits that will be pushed with this git push before running `git push`. This confirm step must be done before you execute `git push`. Then let me choose y or n - if y, execute the git push; if n, abort the process.
