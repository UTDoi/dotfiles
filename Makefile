DOTFILES_EXCLUDES  := .DS_Store .git .gitmodules
DOTFILES_TARGET    := $(wildcard .??*)
DOTFILES_FILES     := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
VSCODE_DOT_DIR := vscode
VSCODE_SETTING_FILES := settings.json keybindings.json
VSCODE_SETTING_DIR := $(HOME)/Library/Application\ Support/Code/User
ZSH_DOT_DIR := zsh

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(VSCODE_SETTING_FILES), ln -sfnv $(abspath $(VSCODE_DOT_DIR)/$(val)) $(VSCODE_SETTING_DIR)/$(val);)

install:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle
	$(VSCODE_DOT_DIR)/install.sh

dump:
	rm -f Brewfile
	brew bundle dump
	code --list-extensions > $(VSCODE_DOT_DIR)/extensions
