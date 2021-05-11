# dotfiles


## prerequisites
Install XCode Command-Line Tools.
```
xcode-select --install
```

## install
TODO: 以下の手順をまとめてやってくれるshell scriptをexc/installer.sh に用意し、`$ bash -c "$(curl -L dot.UTDoi.com)"`みたいな感じで実行できるようにする

```
$ git clone https://github.com/UTDoi/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ make install
$ make deploy
$ echo $(brew --prefix)/bin/zsh | sudo tee -a /etc/shells
$ chsh -s $(brew --prefix)/bin/zsh
```

## compile
After installing or updating dotfiles, execute compile command.
Your zsh will initialize more faster.

```
$ make compile
```

## dump
Dump homebrew packages and vscode extensions list to files.

After installing packages directly, execute this command for updating the dotfiles repo to reflect the changes.

```
$ make dump
```
