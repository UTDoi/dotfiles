# jira-cli gotchas

- Body (`-b`) is parsed as **Markdown**, not Jira wiki markup. Do NOT write `h2.`, `{code}`, etc. — they render literally
- Do NOT use fenced code blocks inside list items (they break). Use inline backticks instead
- Angle brackets (`map<string,string>`, etc.) are stripped as HTML outside backticks. Always wrap them in backticks
- `jira issue create/edit/comment add` hangs on stdin in non-interactive shells. Always append `< /dev/null`
- When updating body with `jira issue edit`, pipe via stdin without the `-b` flag. `-b -` corrupts the content
  ```bash
  cat <<'BODY' | jira issue edit CGT-XXXX --no-input < /dev/null
  description content here
  BODY
  ```
- Do NOT include `ORDER BY` in JQL passed via `-q`. jira-cli appends its own ordering, causing a 400 error. Use `--order-by <field> [--reverse]` flag instead
