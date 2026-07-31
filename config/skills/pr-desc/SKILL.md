---
name: "pr-desc"
description: "Create a description for specified github pull request. Triggers on: 'create a PR description', 'PR description'."
---
# pr-desc
The purpose of pr-desc skill is to create a description for GitHub pull requests. 
The target PR is specified by user such as `Create a PR description #100`. If not specified, ask the user to specify PR number.
If there are some existing description in PR, keep those and add your contents at the bottom.

## How to summarize the PR
Reference these information:

- Changes of source code
- Existing PR description


## Template
The description which you're going to create must follow this template:
### Japanese
```md
## 概要
PRに含まれる変更内容を端的に簡潔に説明する。
PRがマージされることによって既存コードベースにどういった影響が与えられるかもここで説明する。

## 主な変更点
最も変更行数の多いファイルを1,2つピックアップして軽い説明を入れる。
```

### English
```md
## Summary
Provide a brief, concise overview of the changes included in this PR. Use this section to explain how merging these changes will impact the existing codebase.

## Key changes
List files which has lots of changes and explain roughly.
```

## Rule
- Select the language based on whether the source code comments are written in Japanese or English
- Update the description of PR using the `gh` command or GitHub MCP server if available.
