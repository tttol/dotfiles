---
allowed-tools: Bash(gh pr view:*), Bash(gh pr list:*), Bash(gh pr diff:*), Bash(mkdir:*)
description: Review a pull request on GitHub and export the discussion to a markdown file.
---

## Context
- Current git status: !`git status`
- Recent commits: !`git log --oneline`

## Your task
- Review a pull request on GitHub and export the discussion to a markdown file.
- Save the markdown file in the `{repository_root}/docs/review/` directory. Create this directory if it doesn't exist. `{repository_root}` refers to the root directory of the repository.
- The markdown file should be named `review_[PR title].md`. Replace spaces, `/`, `+`, and any other characters that aren't allowed in filenames with `-`.
- The template of `review_[PR title].md` is here below.
```markdown
# PR Summaray
PR summary is written here.

# Review Comments
This is where review comments go - things that need fixing, bugs (actual or potential), areas that should be refactored, etc. Please include the source file name and line numbers whenever possible. Each comment needs to have prefix `{must}` or `{should}` or `{nitpicks}`. 
- must: Things that must be fixed such as a critical bug or features not meeting specifications.
- should: Things that should be fixed. Improvements that are strongly recommended.
- nitpicks: Typos and other small corrections.
## {must} The xxx logic does not satisfy a specification(src/core/hoge.java L223)
The detail of comments...

## {nits} Fix typo(src/domain/fuga.java L299)
The detail of comments...
```
