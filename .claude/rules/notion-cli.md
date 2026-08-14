# notion-cli gotchas

- `notion-cli fetch` prepends a `> Source: <url>` line to the output. Always remove this line before `push --update` — otherwise it appears as a blockquote on the Notion page
- Fetched Markdown may contain `<span discussion-urls="...">` attributes representing inline comments/discussions. Preserve these spans during push to retain existing comments. Never delete span tags — edit the text inside the span or append outside it
