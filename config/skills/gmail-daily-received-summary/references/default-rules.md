# Default Rules

Use this file when the user does not supply custom sender rules or a custom output format.

## Important Sender Rules

Treat messages from the following senders as `IMPORTANT MAIL`:

- `info@mail.rakuten-bank.co.jp`
- `toysub@torana.us`
- `order@kobecco-teikibin.jp`
- `jjugccc_office@e-side.co.jp`
- `*@at-parking.jp`

All other senders belong to `GENERAL MAIL`.

## Wildcard Matching

- Support only the simple suffix form `*@domain`.
- Match the wildcard against the sender email address.
- `*@at-parking.jp` matches `noreply@at-parking.jp` and `info@at-parking.jp`.
- Do not treat partial matches such as `foo@sub.at-parking.jp.example.com` as valid.

## Default Output Template

```md
# IMPORTANT MAIL
### XXX / xxx@gmail.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜

### YYY / yyy@gmail.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜

# GENERAL MAIL
### XXX / xxx@gmail.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜

### YYY / yyy@gmail.com（5件）
〜〜の件について連絡がありました。内容は〜〜〜
```

`XXX` and `YYY` are sender names.

## Query Baseline

Use this Gmail query pattern unless the user asks for a different scope:

```text
after:<previous-day> before:<next-day> -from:me -in:spam -in:trash
```

Then re-filter the returned timestamps in the target timezone to remove Gmail date-search spillover.
