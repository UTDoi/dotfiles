#!/usr/bin/env bash
# git-guard: PreToolUse hook (matcher: Bash)
# Guards: force push, remote branch/tag deletion, push to protected branches,
# and git checkout pathspec forms that overwrite uncommitted changes.
set -u

cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
case "$cmd" in *git*) ;; *) exit 0 ;; esac

emit() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' "$1" "$2"
  exit 0
}

if printf '%s' "$cmd" | grep -q 'git push'; then
  # force push: --force-with-lease asks, --force/-f/+refspec is denied
  printf '%s' "$cmd" | grep -qE '(^|[[:space:]])--force-with-lease(=[^[:space:]]*)?([[:space:]]|$)' \
    && emit ask "force-with-lease push: confirm this is a solo feature branch."
  printf '%s' "$cmd" | grep -qE '(^|[[:space:]])(--force|-f)([[:space:]]|$)|[[:space:]]\+[^[:space:]]' \
    && emit deny "Force push is blocked. Use --force-with-lease if truly needed."
  # remote branch/tag deletion
  printf '%s' "$cmd" | grep -qE '(^|[[:space:]])(--delete|-d|--mirror|--prune)([[:space:]]|$)|[[:space:]]:[^[:space:]]' \
    && emit deny "Remote branch/tag deletion is blocked."
  # push to protected branches: explicit in command, or current branch is protected.
  # Personal repos (github.com/UTDoi/*) are exempt; the ask rule on git push still prompts.
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
  remote=$(git remote get-url origin 2>/dev/null || echo "")
  case "$remote" in
    *github.com[:/]UTDoi/*) : ;;
    *)
      { printf '%s' "$cmd" | grep -qE '[[:space:]/:](main|master|develop)([[:space:]]|$)' \
        || printf '%s\n' "$branch" | grep -qxE 'main|master|develop'; } \
        && emit deny "Push to protected branch (main/master/develop) is blocked. Use a feature branch + PR."
      ;;
  esac
fi

# git checkout with a pathspec (" -- " or " .") overwrites uncommitted changes;
# prefix permission rules cannot catch these mid-command forms.
printf '%s' "$cmd" | grep -qE 'git checkout[^|;&]*([[:space:]]--([[:space:]]|$)|[[:space:]]\.([[:space:]]|$)|[[:space:]]\.$)' \
  && emit ask "git checkout with a pathspec overwrites uncommitted changes. Confirm."

exit 0
