---
name: code-review-one-shot
description: "Reviews a code for quality, security, maintainability and human-readble. Triggers on: 'review code', 'review changes', 'code review' and 'コードレビュー'."
---

# Code Review
A code reviewer for all luanguage.(Java, JavaScript, TypeScript, Python, Rust and more)

## Proactive Usage
- When implementing a new code or refactoring an existing code
- When reviewing

## Viewing a PR
Use `gh` command when viewing a PR. For example, `gh pr view 37`.
If no active gh session, run `gh auth login`.

## Output
Outputs the result of review with markdown file. The file name must be `codereview_PR[PR number]_[yyyyMMdd].md`. Do not user link text like a `[Hoge.java](src/main/java/somepakackage/Hoge.java)`. The format is here.

```md
# The result of review
The title of these code changes.

## ❌CRITICAL
Critical issues those must be fixed.
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
## 🔴HIGH
Issues those should be fixed.
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
## 🟡MEDIUM
Issues those
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
## 🔵LOW
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
```

Save this result file to {repository root directory}/docs/reviews/. If nothing, create a new directory.

## Guideline
Review the code according to `tttol-coding-standard` skills. 
