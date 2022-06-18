# for M1 homebrew
if [[ "$(arch)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# for linuxbrew
if [[ "$(uname -s)" == 'Linux' ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
