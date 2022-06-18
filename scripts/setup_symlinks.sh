#!/bin/bash -ue

DOTFILES_DIR="$HOME/src/github.com/UTDoi/dotfiles"
source $DOTFILES_DIR/scripts/utils.sh

# files placed at $HOME/
TARGET_DOTFILES=(
  .commit_template
  .gitconfig
  .gitignore_global
  .p10k.zsh
  .pryrc
  .tigrc
  .tmux.conf
  .zshenv
)

# directories placed at $HOME/
TARGET_DOTDIRS=(
  .git_template
  .hammerspoon
)

# directories placed at $HOME/.config/
TARGET_CONFIG_DIRS=(
  gh
  karabiner
  nvim
)

# files placed at $VSCODE_SETTING_DIR/
TARGET_VSCODE_SETTING_FILES=(
  settings.json
  keybindings.json
)

VSCODE_SETTING_DIR=$(HOME)/Library/Application\ Support/Code/User

get_file_path_in_dotfiles_dir() {
  find $DOTFILES_DIR -type f -name "$1"
}

get_dir_path_in_dotfiles_dir() {
  find $DOTFILES_DIR -type d -name "$1"
}

link_to_home() {
  for TARGET_DOTFILE in ${TARGET_DOTFILES[@]}; do
    TARGET_PATH=`get_file_path_in_dotfiles_dir $TARGET_DOTFILE`
    log_info "Put "~/$TARGET_DOTFILE" symbolic link ..."
    ln -snf $TARGET_PATH $HOME
  done

  for TARGET_DOTDIR in ${TARGET_DOTDIRS[@]}; do
    TARGET_PATH=`get_dir_path_in_dotfiles_dir $TARGET_DOTDIR`
    log_info "Put "~/$TARGET_DOTDIR" symbolic link ..."
    ln -snf $TARGET_PATH $HOME
  done
}

link_to_config_dir() {
  for TARGET_CONFIG_DIR in ${TARGET_CONFIG_DIRS[@]}; do
    TARGET_PATH=`get_dir_path_in_dotfiles_dir $TARGET_CONFIG_DIR`
    log_info "Put "~/.config/$TARGET_CONFIG_DIR" symbolic link ..."
    ln -snf $TARGET_PATH $HOME/.config
  done
}

link_to_vscode_setting_dir() {
  for TARGET_VSCODE_SETTING_FILE in ${TARGET_VSCODE_SETTING_FILES[@]}; do
    TARGET_PATH=`get_file_path_in_dotfiles_dir $TARGET_VSCODE_SETTING_FILE`
    log_info "Put "$VSCODE_SETTING_DIR/$TARGET_VSCODE_SETTING_FILE" symbolic link ..."
    ln -snf $TARGET_PATH $VSCODE_SETTING_DIR
  done
}

setup_symlinks() {
  log_info "Start setup symbolic link..."
  link_to_home
  link_to_config_dir
  if is_darwin; then
    link_to_vscode_setting_dir
  fi
  log_pass "Setup symbolic links complete! ✔"
}

# If you want to run, pass something as an argument
if [ $# != 0 ]; then
  setup_symlinks
fi
