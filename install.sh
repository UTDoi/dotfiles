#!/bin/bash -ue

DOTFILES_DIR="$HOME/src/github.com/UTDoi/dotfiles"
DOT_REMOTE_URL="https://github.com/UTDoi/dotfiles.git"

is_exists() {
  type "$1" >/dev/null 2>&1
  return $?
}

download_dotfiles() {
  if [ ! -d $DOTFILES_DIR ]; then
    echo $(tput setaf 2)Downloading dotfiles...$(tput sgr0)

    mkdir -p $DOTFILES_DIR

    if is_exists "git"; then
      git clone ${DOT_REMOTE_URL} ${DOTFILES_DIR} && true
    else
      echo $(tput setaf 1)You must install git$(tput sgr0)
      exit 1
    fi

    echo $(tput setaf 2)Download dotfiles complete!. ✔︎$(tput sgr0)
    cd $DOTFILES_DIR
  else
    echo $(tput setaf 2)Your dotfiles has been already installed.$(tput sgr0)
  fi
}

download_dotfiles

source $DOTFILES_DIR/scripts/install_tools.sh
source $DOTFILES_DIR/scripts/setup_symlinks.sh

if [ $# == 0 ]; then
  install_tools
  setup_symlinks
else
  case $1 in
    "tools")
      install_tools
      ;;
    "link")
      setup_symlinks
      ;;
  esac
fi

exit 0
