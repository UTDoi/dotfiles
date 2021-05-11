() {
  local src
  for src in $@; do
    ([[ ! -e $src.zwc ]] || [ $src -nt $src.zwc ]) && zcompile $src
  done
} $ZDOTDIR/.zshrc $ZDOTDIR/.zshenv

echo 'zcompile successful!'

