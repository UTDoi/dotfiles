#!/bin/bash -ue

DOTFILES_DIR="$HOME/src/github.com/UTDoi/dotfiles"
source $DOTFILES_DIR/scripts/utils.sh

# files placed at $HOME/
TARGET_DOTFILES=(
  .gitconfig
  .gitignore_global
  .p10k.zsh
  .tigrc
  .tmux.conf
  .zshenv
  .asdfrc
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

# files placed at $HOME/.claude/
TARGET_CLAUDE_FILES=(
  CLAUDE.md
  settings.json
)

# directories placed at $HOME/.claude/
TARGET_CLAUDE_DIRS=(
  commands
)

VSCODE_SETTING_DIR="$HOME/Library/Application Support/Code/User"

get_file_path_in_dotfiles_dir() {
  find $DOTFILES_DIR -type f -name "$1" -maxdepth 1
}

get_file_path_in_vscode_dir() {
  find $DOTFILES_DIR/vscode -type f -name "$1" -maxdepth 1
}

get_file_path_in_claude_dir() {
  find $DOTFILES_DIR/.claude -type f -name "$1" -maxdepth 1
}

get_dir_path_in_claude_dir() {
  find $DOTFILES_DIR/.claude -type d -name "$1" -maxdepth 1
}

get_dir_path_in_dotfiles_dir() {
  find $DOTFILES_DIR -type d -name "$1"
}

link_to_home() {
  for TARGET_DOTFILE in ${TARGET_DOTFILES[@]}; do
    TARGET_PATH=`get_file_path_in_dotfiles_dir $TARGET_DOTFILE`
    ln -snfv $TARGET_PATH $HOME
  done

  for TARGET_DOTDIR in ${TARGET_DOTDIRS[@]}; do
    TARGET_PATH=`get_dir_path_in_dotfiles_dir $TARGET_DOTDIR`
    ln -snfv $TARGET_PATH $HOME
  done
}

link_to_config_dir() {
  if [ ! -d ~/.config ]; then
    mkdir ~/.config
  fi

  for TARGET_CONFIG_DIR in ${TARGET_CONFIG_DIRS[@]}; do
    TARGET_PATH=`get_dir_path_in_dotfiles_dir $TARGET_CONFIG_DIR`
    ln -snfv $TARGET_PATH $HOME/.config
  done
}

link_to_vscode_setting_dir() {
  for TARGET_VSCODE_SETTING_FILE in ${TARGET_VSCODE_SETTING_FILES[@]}; do
    TARGET_PATH=`get_file_path_in_vscode_dir $TARGET_VSCODE_SETTING_FILE`
    ln -snfv $TARGET_PATH "$VSCODE_SETTING_DIR"
  done
}

link_to_claude_dir() {
  if [ ! -d ~/.claude ]; then
    mkdir ~/.claude
  fi

  for TARGET_CLAUDE_FILE in ${TARGET_CLAUDE_FILES[@]}; do
    TARGET_PATH=`get_file_path_in_claude_dir $TARGET_CLAUDE_FILE`
    ln -snfv $TARGET_PATH $HOME/.claude
  done

  for TARGET_CLAUDE_DIR in ${TARGET_CLAUDE_DIRS[@]}; do
    TARGET_PATH=`get_dir_path_in_claude_dir $TARGET_CLAUDE_DIR`
    ln -snfv $TARGET_PATH $HOME/.claude
  done
}

setup_symlinks() {
  log_info "Start setup symbolic link..."
  link_to_home
  link_to_config_dir
  link_to_claude_dir
  if is_darwin; then
    link_to_vscode_setting_dir
  fi
  log_pass "Setup symbolic links complete! ✔"
}
