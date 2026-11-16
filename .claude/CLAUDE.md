# CLAUDE.md - Global Configuration

## Code Comments

Write a comment only where the code cannot say it. When the code alone makes the intent obvious, write none.

- **Why, not what.** Explain background, design decisions, constraints and workarounds. Don't restate the code or the signature ("X takes it.").
- **Conclusion first.** Start with what the code decides, then why, then (if needed) why it is safe: "Reject X: Y takes too long." Not a list of facts that leaves the reader asking "so what?".
- **Match the scope of what you document.** A comment on a package, type, interface, constructor or shared helper says only what holds for all of it: every method and every caller, including ones added later. One method's behavior goes on that method. The reason a caller uses a helper goes at the call site.
- **Describe by what it does, not by who uses it.** Don't explain a general component by its only caller today, the RPC or screen that uses it, or the code it was ported from. Don't name a type after its only caller.
- **Never invent a reason.** If no design doc or person gave a reason for a value or a decision, state what it means (and that it is provisional, if it is) and stop.
- **Keep the reasons that were agreed.** After a design decision, check every rule the code enforces, and write its why where it is enforced.
- **Present tense, current design.** No history ("no longer", "used to", "moved from"), port origins, PRD scenario or phase numbers, or vague references such as "the next run". Those belong in the PR or the commit.
- **Plain and short.** Every term is defined in the code itself. Write a failure case as "If ..., ..." and name its real trigger.

## Test-Driven Development (TDD)

- Create tests first based on expected inputs and outputs
- Run tests and confirm they fail
- Then implement to make tests pass
- During implementation, do not modify tests — keep fixing code
- Repeat until all tests pass

## Code Quality

- When you notice a significant bug risk, security issue, or performance problem during work, point it out — but don't force a checklist on every interaction
