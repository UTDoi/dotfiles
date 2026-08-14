# General tool usage

- Never guess or fabricate external resource names (Slack channels, PagerDuty services, etc.). Always verify via codebase search, the actual service, or asking the user
- Before claiming a Claude Code internal feature "doesn't exist", grep the installed binary to verify. Official docs may lag or intentionally omit features. Verify with `grep -ac NAME "$(readlink -f $(which claude))"`
- The Edit tool replaces symlinks with regular files. Always check the target with `ls -la` first and edit the real file path, not the symlink
