# dotfiles


## prerequisites
Install XCode Command-Line Tools.
```
xcode-select --install
```

## install
```
$ git clone https://github.com/UTDoi/dotfiles.git ~/src/github.com/UTDoi/dotfiles
$ cd ~/src/github.com/UTDoi/dotfiles
$ make install
$ make deploy
$ echo $(brew --prefix)/bin/zsh | sudo tee -a /etc/shells
$ chsh -s $(brew --prefix)/bin/zsh
```

### optional
If you'd like to save iTerm2 setting automatically, open
```
Preferences > General > Preferences > Save changes
```
and set `Automatically`.


## compile
After installing or updating dotfiles, execute compile command.
Your zsh will initialize faster.

```
$ make compile
```

## dump
Dump homebrew packages and vscode extensions list to files.

After installing packages directly, execute this command for updating the dotfiles repo to reflect the changes.

```
$ make dump
```
