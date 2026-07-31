---
name: aws-account-investigation
description: Investigate AWS resources and issues across configured AWS IAM Identity Center accounts by selecting an account with the user's interactive `as` command. Use when Codex needs to inspect AWS CLI resources, diagnose AWS incidents, verify AWS identity or configuration, or collect AWS account evidence and the correct target account is not already established.
---

# AWS Account Investigation

Use `as` to select and authenticate the AWS profile, then execute the AWS CLI command in that same login shell. This preserves the `AWS_PROFILE` exported by `as`.

## Select an account and investigate

1. Run `scripts/with-as.zsh` with a terminal allocated (`tty: true`) and pass one AWS CLI command as its arguments. The script opens the profile selector and, when required, the IAM Identity Center sign-in flow.
2. Confirm the printed `sts get-caller-identity` output matches the intended AWS account before relying on investigation results.
3. Start with read-only commands such as `aws cloudformation describe-stacks`, `aws logs describe-log-groups`, `aws ecs describe-services`, `aws lambda get-function`, or `aws resourcegroupstaggingapi get-resources`.
4. State the selected account ID, profile, region, and evidence in the response. Do not alter resources unless the user explicitly asks.

```zsh
/Users/tttol/Documents/workspace/dotfiles/config/skills/aws-account-investigation/scripts/with-as.zsh \
  aws cloudformation describe-stacks --region ap-northeast-1
```

## Important constraints

- Do not run `as` and AWS commands in separate shell invocations; its exported `AWS_PROFILE` would be lost.
- Do not pass `--profile` to the AWS command unless the user explicitly requests an override.
- Stop if account selection is cancelled or identity verification fails. Report the failure and ask the user to authenticate or choose the intended account.
- Treat `as` as interactive. Do not attempt to infer or select an account number without the user's input.

## Resource

Use `scripts/with-as.zsh` for every AWS CLI command that requires an interactive account selection.
