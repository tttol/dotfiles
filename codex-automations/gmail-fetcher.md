[@gmail](plugin://gmail@openai-curated) 
Get all emails which I got yesterday then summarize. The summary must be separated by addresses.
These addresses are important. If I got the mail from these lists, put on `IMPORTANT MAILS` section.
- info@mail.rakuten-bank.co.jp
- toysub@torana.us
- order@kobecco-teikibin.jp

Others are put on `GENERAL MAILS` section.

The output template is here:

```
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
