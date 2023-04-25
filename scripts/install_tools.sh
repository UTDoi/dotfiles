#!/bin/bash -eu

DOTFILES_DIR="$HOME/src/github.com/UTDoi/dotfiles"

source $DOTFILES_DIR/scripts/utils.sh
source $DOTFILES_DIR/scripts/install_brew_packages.sh
source $DOTFILES_DIR/scripts/setup_mac_os_config.sh

if is_darwin; then
  if !(is_exists "brew"); then
    log_info "installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # for M1
    if [[ "$(arch)" == "arm64" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi

  log_info "installing brew packages ..."
  install_brew_packages

  if [ $(echo $SHELL) != $(brew --prefix)/bin/zsh ]; then
    echo $(brew --prefix)/bin/zsh | sudo tee -a /etc/shells
    sudo chsh -s $(which zsh) && true
  fi
fi

# aptで必要なツールを持ってくる処理

if [ ! -d ~/.zinit ]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

if is_darwin; then
  log_info "installing vscode extensions ..."
  cat $DOTFILES_DIR/vscode/extensions | while read line
  do
    code --install-extension $line
  done

  log_info "setup mac os config ..."
  setup_mac_os_config

  log_info "load iTerm2 custom plist ..."
  defaults write com.googlecode.iterm2 "LoadPrefsFromCustomFolder" -bool true
  defaults write com.googlecode.iterm2 "PrefsCustomFolder" -string $DOTFILES_DIR/iterm2
fi

log_pass "Installation successful!"
