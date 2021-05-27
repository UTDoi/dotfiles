if [[ ! -n $TMUX ]] && [[ $- == *l* ]] && [[ $TERM_PROGRAM != "vscode" ]]; then
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session \; source-file "$DOTPATH/tmux/new-session"
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | peco | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session \; source-file "$DOTPATH/tmux/new-session"
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :
  fi
fi

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
  alias j='z'
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

: 'bindkeys' && {
  bindkey '^a' beginning-of-line
  bindkey '^b' backward-char
  bindkey '^e' end-of-line
  bindkey '^f' forward-char
  bindkey '^k' kill-line
  bindkey '^n' down-line-or-history
  bindkey '^p' up-line-or-history
  bindkey '^r' history-incremental-search-backward # TODO: 後で fzf 使った widget に変える
  bindkey 'ƒ' forward-word # Option + f
  bindkey '∫' backward-word # Option + b
}

: 'zinit plugins' && {
  zinit ice depth=1 atload"!source ~/.p10k.zsh"
  zinit light romkatv/powerlevel10k

  zinit ice wait lucid atload'_zsh_autosuggest_start'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=248'; bindkey 'J' autosuggest-accept
  zinit light zsh-users/zsh-autosuggestions

  zinit ice wait lucid as"program" src"z.sh"
  zinit load "rupa/z"

  zinit ice wait'1' lucid
  zinit light zdharma/fast-syntax-highlighting

  zinit ice wait'1' lucid as"program" pick"hub/etc/hub.zsh_completion"
  zinit light github/hub

  zinit ice wait'2' lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

  zinit ice wait'2' lucid as"program" pick "contrib/completion/git-completion.zsh"
  zinit light git/git

  zinit ice wait'2' lucid as"program" pick"bin/git-dsf"
  zinit light zdharma/zsh-diff-so-fancy

  zinit ice wait'3' lucid as"program" pick"cli/contrib/completion/zsh/_docker" atload"export DOCKER_BUILDKIT=1"
  zinit light docker/cli

  zinit ice wait'3' lucid as"program" pick"compose/contrib/completion/zsh" atload"export COMPOSE_DOCKER_CLI_BUILD=1"
  zinit light docker/compose
}

: 'initialize completion' && {
  autoload -U compinit && compinit

  : 'for awscli completion' && {
    autoload bashcompinit && bashcompinit
    AWS_COMPLETER_PATH=$(which aws_completer)
    complete -C ${AWS_COMPLETER_PATH}
  }
}
