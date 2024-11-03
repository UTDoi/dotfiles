#!/bin/bash -u

DOTFILES_DIR="$HOME/src/github.com/UTDoi/dotfiles"
source $DOTFILES_DIR/scripts/utils.sh

# CUI tools
target_brew_list=(
  asdf
  awscli
  bat
  glib
  llvm
  ccls
  direnv
  eza
  fd
  fzf
  gh
  ghq
  git
  git-secrets
  node
  gitmoji
  gobject-introspection
  harfbuzz
  pango
  librsvg
  graphviz
  jq
  krb5
  libevent
  libmagic
  libpq
  neovim
  nghttp2
  protobuf
  pstree
  ripgrep
  shared-mime-info
  sops
  stern
  swig
  tmux
  tig
  tree
  yarn
  zsh
)

# CUI tools for only macOS
target_brew_list_for_mac_os=(
  coreutils
  findutils
  gnu-sed
  grep
  gzip
  gawk
  gnu-tar
  wget
)

# GUI tools
target_brew_cask_list=(
  alfred
  clipy
  hammerspoon
  iterm2
  karabiner-elements
  visual-studio-code
  postman
  font-hackgen-nerd
)

install_brew_packages() {
  for target in ${target_brew_list[@]}; do
    if ! is_exists "$target"; then
      brew install $target
    else
      log_info "$target has been already installed."
    fi
  done

  if is_darwin; then
    for target in ${target_brew_list_for_mac_os[@]}; do
      if ! is_exists "$target"; then
        brew install $target
      else
        log_info "$target has been already installed."
      fi
    done

    for target in ${target_brew_cask_list[@]}; do
      if ! is_exists "$target"; then
        brew install --cask $target
      else
        log_info "$target has been already installed."
      fi
    done
  fi
}
