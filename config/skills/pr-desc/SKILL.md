---
name: "pr-desc"
description: "Create a description for specified github pull request. Triggers on: 'create a PR description', 'PR description'."
---
# pr-desc
The purpose of pr-desc skill is to create a description for GitHub pull requests. 
The target PR is specified by user such as `Create a PR description #100`. If not specified, ask the user to specify PR number.

## Template
The description which you're going to create must follow this template:
### Japanese
```md
## 概要
PRに含まれる変更内容を端的に簡潔に説明する。
PRがマージされることによって既存コードベースにどういった影響が与えられるかもここで説明する。

## 背景
変更の裏側にある背景や事情を説明する。JIRAチケットなどから情報を取得して加工する。

## 変更内容
変更を加えたファイルのうち変更行数が多いものを上位3つほど取り上げ、変更内容をソースコードレベルで説明する。差分のあるファイルが4ファイル以上ある場合は上位3つだけでよい。
```

### English
```md
Summary
Provide a brief, concise overview of the changes included in this PR. Use this section to explain how merging these changes will impact the existing codebase.

Background
Explain the context or motivation behind these changes. You can pull and adapt relevant details from JIRA tickets or other documentation.

Key Changes
Highlight the top three files with the most significant changes and explain the modifications at the source-code level. If the PR affects four or more files, focusing on the top three is sufficient.
```

## Rule
- Select the language based on whether the source code comments are written in Japanese or English
- Update the description of PR using the `gh` command or GitHub MCP server if available.
