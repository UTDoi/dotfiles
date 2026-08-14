---
paths:
  - "**/*.go"
---

- Never ignore error returns
- `context.Context` is always the first parameter for I/O functions
- Accept interfaces, return concrete types
- Use `defer` for cleanup, but be aware of loop gotchas
- Prefer channels over shared memory for concurrency
