---
name: gmail-daily-received-summary
description: Summarize Gmail messages received on a target day, usually yesterday, and group the result by sender address. Use when Codex needs to analyze Gmail inbox traffic for a day, split important senders into a dedicated section, apply wildcard sender rules such as `*@domain`, handle Gmail date-search timezone spillover, and produce a sender-grouped daily report for automations or inbox review.
---

# Gmail Daily Received Summary

## Overview

Use Gmail-native search to collect received mail for one JST day, then regroup the result by sender and render two sections: `IMPORTANT MAIL` and `GENERAL MAIL`.

Read [references/default-rules.md](references/default-rules.md) when the user does not provide a sender allowlist, wildcard rules, or an output template.

## Workflow

1. Determine the target day.
   - Prefer an explicit date from the user.
   - For relative requests such as "yesterday", resolve the date in the user's timezone and restate the absolute date in the answer.
   - For the default automation in Japan, treat "yesterday" as a JST date boundary.
2. Search Gmail with `search_emails`.
   - Start with a date window that safely covers the target day, for example `after:<previous-day> before:<next-day> -from:me -in:spam -in:trash`.
   - Exclude self-sent summaries unless the user explicitly wants them.
   - Prefer `max_results` around 50 unless the mailbox volume is clearly higher.
3. Re-filter by timestamp after search.
   - Gmail date search can include timezone spillover.
   - Convert each message timestamp to the target timezone and keep only messages that actually fall on the target calendar day.
4. Normalize sender identity.
   - Extract sender display name and sender email address from `from_`.
   - Group by sender email address, not by subject or thread.
   - Preserve the most useful sender display name for the section heading.
5. Classify senders.
   - Match exact sender addresses first.
   - Support wildcard patterns of the form `*@domain`.
   - If no custom rules are provided, use the defaults from [references/default-rules.md](references/default-rules.md).
6. Summarize each sender group.
   - Count the number of messages from that sender.
   - Read bodies only when snippets and subjects are insufficient.
   - Produce a 1-2 sentence Japanese summary describing the main topics across that sender's messages.
   - Merge repetitive notifications into a single concise description.
7. Render the final report.
   - Output `IMPORTANT MAIL` first, then `GENERAL MAIL`.
   - Use the sender name, sender address, and message count in each heading.
   - If a section has no entries, write `該当なし`.

## Output Rules

- Answer in Japanese unless the user explicitly requires another language.
- Keep the exact section titles and heading shape when the user provides a template.
- Do not infer urgency from Gmail's built-in `IMPORTANT` label. Only use the configured sender rules.
- Mention timezone filtering when Gmail search results include messages outside the target JST day.
- If the user asks for "all emails", treat the task as coverage-oriented and avoid sampling.

The template for output is here:
```md
# IMPORTANT MAIL
### XXX / xxx@gmal.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜

### YYY / yyy@gmal.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜

# GENERAL MAIL
### XXX / xxx@gmal.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜

### YYY / yyy@gmal.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜
```

`XXX` and `YYY` are sender name.

## Validation

- Check that every included message timestamp falls on the target day in the chosen timezone.
- Check that each sender appears in exactly one section.
- Check that wildcard matches such as `*@at-parking.jp` are evaluated against the sender email domain.
- Check that the reported counts match the number of retained messages in each sender group.
