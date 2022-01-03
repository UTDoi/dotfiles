DOTFILES_EXCLUDES  := .DS_Store .git
DOTFILES_TARGET    := $(wildcard .??*)
DOTFILES_FILES     := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
VSCODE_SETTING_FILES := settings.json keybindings.json
VSCODE_SETTING_DIR := $(HOME)/Library/Application\ Support/Code/User
GH_CONFIG_FILE_PATH := gh/config.yml
KARABINER_CONFIG_FILE_PATH := karabiner/karabiner.json
NVIM_CONFIG_FILE_PATH := nvim/init.vim
XDG_CONFIG_FILE_PATHS := $(GH_CONFIG_FILE_PATH) $(KARABINER_CONFIG_FILE_PATH) $(NVIM_CONFIG_FILE_PATH)


deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(VSCODE_SETTING_FILES), ln -sfnv $(abspath vscode/$(val)) $(VSCODE_SETTING_DIR)/$(val);)
	@$(foreach val, $(XDG_CONFIG_FILE_PATHS), ln -sfnv $(abspath $(XDG_CONFIG_HOME)/$(val)) $(val);)

install:
	./macos.sh
	./install.sh

compile:
	@$(brew --prefix)/bin/zsh ./zcompile.sh

dump:
	rm -f Brewfile
	brew bundle dump
	code --list-extensions > $(VSCODE_DOT_DIR)/extensions
