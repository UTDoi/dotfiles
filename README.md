# dotfiles

## prerequisites
Install git command before following steps.
If your computer's OS is macOS, you should install XCode Command-Line Tools.
```
xcode-select --install
```

## install
Execute this one-liner.
```
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/UTDoi/dotfiles/master/install.sh)"
```

After installed, you can execute command like this to re-symlink files.
```
$ ./install.sh link
```

Also, you can re-install tools.
```
$ ./install.sh tools
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
$ ./zcompile.sh
```
