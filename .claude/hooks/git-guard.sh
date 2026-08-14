#!/usr/bin/env bash
# git-guard: PreToolUse hook (matcher: Bash)
# Guards: force push, remote branch/tag deletion, push to protected branches,
# and git checkout pathspec forms that overwrite uncommitted changes.
set -u

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
case "$cmd" in *git*) ;; *) exit 0 ;; esac

emit() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' "$1" "$2"
  exit 0
}

# Quoted strings (commit messages etc.) must not trigger the guards below,
# e.g. git commit -m "explain git push --force".
stripped=$(printf '%s' "$cmd" | sed -E "s/'[^']*'//g; s/\"[^\"]*\"//g")

# Match an actual `git [-C <dir>] push` invocation at a command position,
# not the substring "git push" inside unrelated text.
push_re='(^|[;&|[:space:]])git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?push([[:space:]]|$)'

# Resolve effective git directory, best-effort:
# `git -C <dir>` > leading `cd <dir> &&` > session cwd from hook input.
# The hook process cwd is not the Bash tool's persistent cwd, so start from
# the cwd Claude Code reports on stdin.
git_dir=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
git_dir="${git_dir:-.}"
resolve_dir() {
  case "$1" in
    "~") printf '%s' "$HOME" ;;
    "~/"*) printf '%s' "$HOME/${1#"~/"}" ;;
    /*) printf '%s' "$1" ;;
    *) printf '%s' "$git_dir/$1" ;;
  esac
}
if dir=$(printf '%s' "$cmd" | sed -nE 's/^cd[[:space:]]+"?([^";&]+[^"[:space:];&])"?[[:space:]]*&&.*/\1/p') && [ -n "$dir" ]; then
  git_dir=$(resolve_dir "$dir")
fi
if dir=$(printf '%s' "$stripped" | sed -nE 's/.*git[[:space:]]+-C[[:space:]]+([^[:space:]]+).*/\1/p') && [ -n "$dir" ]; then
  git_dir=$(resolve_dir "$dir")
fi

if printf '%s' "$stripped" | grep -qE "$push_re"; then
  # force push: --force-with-lease asks, --force/-f/+refspec is denied
  printf '%s' "$stripped" | grep -qE '(^|[[:space:]])--force-with-lease(=[^[:space:]]*)?([[:space:]]|$)' \
    && emit ask "force-with-lease push: confirm this is a solo feature branch."
  printf '%s' "$stripped" | grep -qE '(^|[[:space:]])(--force|-f)([[:space:]]|$)|[[:space:]]\+[^[:space:]]' \
    && emit deny "Force push is blocked. Use --force-with-lease if truly needed."
  # remote branch/tag deletion
  printf '%s' "$stripped" | grep -qE '(^|[[:space:]])(--delete|-d|--mirror|--prune)([[:space:]]|$)|[[:space:]]:[^[:space:]]' \
    && emit deny "Remote branch/tag deletion is blocked."
  # push to protected branches: explicit in command, or current branch is protected.
  # Personal repos (github.com/UTDoi/*) are exempt; the ask rule on git push still prompts.
  branch=$(git -C "$git_dir" symbolic-ref --short HEAD 2>/dev/null || echo "")
  remote=$(git -C "$git_dir" remote get-url origin 2>/dev/null || echo "")
  case "$remote" in
    *github.com[:/]UTDoi/*) : ;;
    *)
      { printf '%s' "$stripped" | grep -qE '[[:space:]/:](main|master|develop)([[:space:]]|$)' \
        || printf '%s\n' "$branch" | grep -qxE 'main|master|develop'; } \
        && emit deny "Push to protected branch (main/master/develop) is blocked. Use a feature branch + PR."
      ;;
  esac
fi

# git checkout with a pathspec (" -- " or " .") overwrites uncommitted changes;
# prefix permission rules cannot catch these mid-command forms.
printf '%s' "$stripped" | grep -qE 'git checkout[^|;&]*([[:space:]]--([[:space:]]|$)|[[:space:]]\.([[:space:]]|$)|[[:space:]]\.$)' \
  && emit ask "git checkout with a pathspec overwrites uncommitted changes. Confirm."

exit 0
