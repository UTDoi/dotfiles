DOTFILES_EXCLUDES  := .DS_Store .git
DOTFILES_TARGET    := $(wildcard .??*)
DOTFILES_FILES     := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
VSCODE_DOT_DIR := vscode
VSCODE_SETTING_FILES := settings.json keybindings.json
VSCODE_SETTING_DIR := $(HOME)/Library/Application\ Support/Code/User
GH_CONFIG_FILE := config.yml
GH_CONFIG_DOT_DIR := gh
GH_CONFIG_BASE_DIR := $(HOME)/.config/gh

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(VSCODE_SETTING_FILES), ln -sfnv $(abspath $(VSCODE_DOT_DIR)/$(val)) $(VSCODE_SETTING_DIR)/$(val);)
	@ln -sfnv $(abspath $(GH_CONFIG_DOT_DIR)/$(GH_CONFIG_FILE)) $(GH_CONFIG_BASE_DIR)/$(GH_CONFIG_FILE);

install:
	./macos.sh
	./install.sh

compile:
	@$(brew --prefix)/bin/zsh ./zcompile.sh

dump:
	rm -f Brewfile
	brew bundle dump
	code --list-extensions > $(VSCODE_DOT_DIR)/extensions
