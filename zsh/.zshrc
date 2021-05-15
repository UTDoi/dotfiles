# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

: 'zinit setting' && {
  source ~/.zinit/bin/zinit.zsh

  if [[ ! -f ${HOME}/.zinit/bin/zinit.zsh.zwc ]]; then
    zinit self-update
  fi
}

: 'anyenv setting' && {
  eval "$(anyenv init -)"

  ANYENV_DEFINITION_ROOT=${HOME}/.config/anyenv/anyenv-install
  ANYENV_ROOT=$(anyenv root)

  if [ ! -d ${ANYENV_DEFINITION_ROOT} ]; then
    anyenv install --init
  fi

  if [[ ! -d ${ANYENV_ROOT}/plugins/anyenv-update ]]; then
    mkdir -p ${ANYENV_ROOT}/plugins
    git clone https://github.com/znz/anyenv-update.git ${ANYENV_ROOT}/plugins/anyenv-update
  fi
}

: 'direnv setting' && {
  eval "$(direnv hook zsh)"
}

: 'configuration for common' && {
  autoload -Uz colors && colors

  setopt auto_cd
  setopt auto_pushd
  setopt correct
  setopt extended_glob
  setopt ignoreeof
  setopt interactive_comments
  setopt nolistbeep
  setopt no_beep
  setopt no_flow_control
  setopt no_tify
  setopt print_eight_bit
  setopt pushd_ignore_dups

  unsetopt list_types
}

: "configuration for history" && {
  HISTFILE=$HOME/.zhistory
  HISTSIZE=1000000
  SAVEHIST=1000000
  setopt extended_history
  setopt hist_ignore_dups
  setopt hist_ignore_all_dups
  setopt hist_no_store
  setopt hist_reduce_blanks
  setopt hist_verify
  setopt inc_append_history
  setopt share_history
}

: 'configuration for completion' && {
  setopt complete_in_word
  setopt list_packed
  setopt auto_param_keys
  setopt always_last_prompt

  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*' format '%B%d%b'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  zstyle ':completion:*' ignore-parents parent pwd ..
  zstyle ':completion:*' menu select=2
  zstyle ':completion:*:*:docker:*' option-stacking yes
  zstyle ':completion:*:*:docker-*:*' option-stacking yes
  zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin
  zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'
  zstyle ':completion:*:processes' command 'ps x -o pid,stat,%cpu,%mem,cputime,command'
}

: 'aliases' && {
  alias gcinolint='SKIP_ESLINT=1 git ci'
  alias gip='git push origin HEAD'
  alias lint='npm run eslint-fix'
  alias fspec='SKIP_SEED=1 bin/rspec'
  alias rubocop='bundle ex rubocop -a'
  alias gipf='git push -f origin HEAD'
  alias k='kubectl'
  alias ls='ls -G'
  alias login='exec $SHELL -l'
}

: 'functions' && {
  function lintall ()
  {
    for jsfile in $(git st | awk '{print $2}' | grep -E '^front/javascripts/components/.+\.js$')
    do
        lint $jsfile
    done
  }
}

: 'zinit plugins' && {
  # Powerlevel10k
  zinit ice depth=1 atload"!source ~/.p10k.zsh"
  zinit light romkatv/powerlevel10k

  # completion
  # zinit ice wait'0'; zinit load zsh-users/zsh-completions
  # zinit ice wait'0'; zinit load zsh-users/zsh-autosuggestions
  # zinit ice wait'0'; zinit load glidenote/hub-zsh-completion
  # zinit ice wait'0'; zinit load Valodim/zsh-curl-completion
  # zinit ice wait'0'; zinit load docker/cli
  # zinit ice wait'0'; zinit load nnao45/zsh-kubectl-completion

  # # coloring
  # zinit load chrissicool/zsh-256color
  # zinit load zsh-users/zsh-syntax-highlighting

  # # expanding aliases
  # zinit load momo-lab/zsh-abbrev-alias

  # # emoji
  # if (($+commands[jq])); then
  #   zinit ice wait'0'; zinit load b4b4r07/emoji-cli
  # fi

  # # Find and display frequently used displays
  # zinit load rupa/z
}

: 'initialize completion' && {
  autoload -U compinit && compinit

  : 'for awscli completion' && {
    autoload bashcompinit && bashcompinit
    AWS_COMPLETER_PATH=$(which aws_completer)
    complete -C ${AWS_COMPLETER_PATH}
  }
}
