---
name: update-project
description: "Updates or saves the project's CLAUDE.md or AGENTS.md files based on a Pull Request. Use this skill to document the specific changes implemented within a Pull Request. Triggers on: `update CLAUDE.md`, `update AGENTS.md`, `CLAUDE.mdを更新して`, `AGENTS.mdを更新して`, `PRの内容をドキュメントに反映`."
---

# Update Project
A skill that updates the project's CLAUDE.md or AGENTS.md based on Pull Request content.

## Usage
Receives a PR number or PR URL from the user and reflects its content in the documentation. Use `gh` command when viewing a PR. For example, `gh pr view 37`.

### Input Format
Specify the PR in one of the following formats:
- PR number: `#123` or `123`
- PR URL: `https://github.com/owner/repo/pull/123`

### Target File

If not specified by the user, the target file is determined by the following priority:
1. `CLAUDE.md` - if it exists in the project root
2. `AGENTS.md` - if CLAUDE.md does not exist

## Workflow

### Step 1: Retrieve PR Information
```bash
# Get PR details from PR number
gh pr view <PR_NUMBER> --json title,body,files,additions,deletions,changedFiles

# Get list of changed files
gh pr view <PR_NUMBER> --json files --jq '.files[].path'

# Get PR diff (for detailed change review)
gh pr diff <PR_NUMBER>
```

### Step 2: Analyze PR Content
Analyze the following from the retrieved information:
- PR title and description
- Types and content of changed files
- Change category (new feature, bug fix, refactoring, etc.)
- Important changes that developers should know

### Step 3: Determine Documentation Updates
Judge what should be added to CLAUDE.md/AGENTS.md from the following perspectives:

**Content to Add:**
- Usage instructions for new commands or scripts
- New configuration files or environment variables
- Architecture changes
- Important dependency additions or changes
- Development notes and best practices
- Directory structure changes
- Breaking changes in core logic
- A new feature, screen or endpoint that developer implemented

**Content NOT to Add:**
- Simple bug fixes (those that don't affect documentation)
- Internal refactoring (no changes to external interfaces)
- Test code only changes / document only changes

### Step 4: Update Documentation
1. Read existing CLAUDE.md/AGENTS.md
2. Identify appropriate section or create a new one
3. Add/update information based on PR content
4. Maintain consistency with existing content

## Output Format
After completion, report in the following format:

```markdown
## Update Complete

**Target PR:** #<PR_NUMBER> - <PR_TITLE>
**Updated File:** <CLAUDE.md or AGENTS.md>

### Added/Changed Content
- <change_1>
- <change_2>

### Updated Sections
- Section: <section_name>
```

## Guidelines
- Accurately reflect PR content
- Maintain consistency with existing documentation style
- Avoid redundant explanations, keep it concise
- Include technical details as needed
- Write in the same language as the existing documentation

## Example
**Input examples:**
- `Update CLAUDE.md with PR #42`
- `Add https://github.com/owner/repo/pull/123 to AGENTS.md`
- `Reflect the latest PR in the documentation`
