#!/bin/bash -eu

script_dir=$(cd $(dirname $0); pwd)

is_exists() {
  type "$1" >/dev/null 2>&1
  return $?
}

ink() {
  if [[ "$#" -eq 0 ]] || [[ "$#" -gt 2 ]]; then
    echo "Usage: ink <color> <text>"
    echo "Colors:"
    echo "  black, white, red, green, yellow, blue, purple, cyan, gray"
    return 1
  fi

  local open="\033["
  local close="${open}0m"
  local black="0;30m"
  local red="1;31m"
  local green="1;32m"
  local yellow="1;33m"
  local blue="1;34m"
  local purple="1;35m"
  local cyan="1;36m"
  local gray="0;37m"
  local white="$close"

  local text="$1"
  local color="$close"

  if [[ "$#" -eq 2 ]]; then
    text="$2"
    case "$1" in (black | red | green | yellow | blue | purple | cyan | gray | white)
      eval color="\$$1"
      ;;
    esac
  fi

  printf "${open}${color}${text}${close}"
}

logging() {
  if [[ "$#" -eq 0 ]] || [[ "$#" -gt 2 ]]; then
    echo "Usage: logging <fmt> <msg>"
    echo "Formatting Options:"
    echo "  TITLE, ERROR, WARN, INFO, SUCCESS"
    return 1
  fi

  local color=
  local text="$2"

  case "$1" in
  TITLE)
    color=yellow
    ;;
  ERROR | WARN)
    color=red
    ;;
  INFO)
    color=blue
    ;;
  SUCCESS)
    color=green
    ;;
  *)
    text="$1"
    ;;
  esac

  timestamp() {
    ink gray "["
    ink purple "$(date +%H:%M:%S)"
    ink gray "] "
  }

  timestamp
  ink "$color" "$text"
  echo
}

log_pass() {
  logging SUCCESS "$1"
}

log_fail() {
  logging ERROR "$1" 1>&2
}

log_warn() {
  logging WARN "$1"
}

log_info() {
  logging INFO "$1"
}

if !(is_exists "brew"); then
  log_info "installing Homebrew ..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
log_info "run brew bundle ..."
brew bundle

if !(is_exists "pip3"); then
  log_fail "please install pip3!!!"
fi
log_info "installing pip libraries ..."
pip3 install awscli-local

if [ ! -d ~/.zinit ]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

log_info "installing vscode extensions ..."
cat vscode/extensions | while read line
do
  code --install-extension $line
done

log_info "load iTerm2 custom plist ..."
defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true
defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string ${script_dir}/iterm2

log_pass "Installation successful!"
