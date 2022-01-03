DOTFILES_EXCLUDES  := .DS_Store .git
DOTFILES_TARGET    := $(wildcard .??*)
DOTFILES_FILES     := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))
VSCODE_SETTING_FILES := settings.json keybindings.json
VSCODE_SETTING_DIR := $(HOME)/Library/Application\ Support/Code/User
XDG_BDS_APP_CONFIG_HOMES := gh karabiner nvim

deploy:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(VSCODE_SETTING_FILES), ln -sfnv $(abspath vscode/$(val)) $(VSCODE_SETTING_DIR)/$(val);)
	@$(foreach val, $(XDG_BDS_APP_CONFIG_HOMES), rm -rf $(XDG_CONFIG_HOME)/$(val); ln -sv $(abspath $(val)) $(XDG_CONFIG_HOME)/$(val);)

install:
	./macos.sh
	./install.sh

compile:
	@$(brew --prefix)/bin/zsh ./zcompile.sh

dump:
	rm -f Brewfile
	brew bundle dump
	code --list-extensions > vscode/extensions
