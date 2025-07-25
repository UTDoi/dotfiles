is_darwin() {
  [ "$(uname -s)" = 'Darwin' ] > /dev/null 2>&1
}

is_linux() {
  [ "$(uname -s)" = 'Linux' ] > /dev/null 2>&1
}

is_exists() {
  type "$1" >/dev/null 2>&1
  return $?
}

if [[ ! -n $TMUX ]] && [[ $- == *l* ]] && [[ $TERM_PROGRAM != "vscode" ]]; then
  ID="`tmux list-sessions`"
  if [[ -z "$ID" ]]; then
    tmux new-session \; source-file "$DOTPATH/tmux/new-session"
  fi
  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"
  ID="`echo $ID | fzf | cut -d: -f1`"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session \; source-file "$DOTPATH/tmux/new-session"
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
  else
    :
  fi
fi

# asdfで管理してるtoolが多いのでこれを先頭に置かないとダメ！
: 'asdf initialize' && {
  if is_darwin; then
    if [[ "$(arch)" == "arm64" ]]; then
      . /opt/homebrew/opt/asdf/libexec/asdf.sh
    else
      . /usr/local/opt/asdf/libexec/asdf.sh
    fi
  else
    export ASDF_DATA_DIR=/opt/asdf-data
    . /opt/asdf/asdf.sh
    fpath=(${ASDF_DIR}/completions $fpath)
  fi
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

: 'fzf setting' && {
  if is_darwin; then
    if [ ! -f ~/.fzf.zsh ]; then
      $(brew --prefix)/opt/fzf/install
    fi
    source ~/.fzf.zsh
  else
    . /usr/share/doc/fzf/examples/completion.zsh
    . /usr/share/doc/fzf/examples/key-bindings.zsh
  fi
}

: 'zinit setting' && {
  source ~/.zinit/bin/zinit.zsh

  if [[ ! -f ${HOME}/.zinit/bin/zinit.zsh.zwc ]]; then
    zinit self-update
  fi
}


: 'direnv setting' && {
  eval "$(direnv hook zsh)"
}

: 'paths' && {
  export PATH=$PATH:$DOTPATH/bin:opt/homebrew/opt
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
  alias home='cd ~'
  alias gip='git push origin HEAD'
  alias gipf='git push -f origin HEAD'
  alias login='exec $SHELL -l'
  alias j='z'
  alias vi='nvim'
  alias vim='nvim'
  alias pr='gh pr list --assignee UTDoi | fzf | cut -f1 | xargs -I {} gh pr checkout {}'
  alias gimtag='aws ecr describe-images --repository-name cfoalpha-app --image-ids imageTag=latest | jq -r ".imageDetails[].imageTags"'
  alias dcns='docker ps | awk '\''{print $2}'\'''
  alias g='git'
  alias rcode='code --remote ssh-remote+yutaro-doi-eng-dev'

  if is_linux; then
    alias bat='batcat'
  fi


  if (($+commands[eza])); then
    alias ls="eza -F"
    alias ll="eza -hlBSF"
    alias ld="eza -ld"
    alias la="eza -aF"
    alias lla="eza -alBSF --icons"
  else
    alias ls="ls -F"
    alias ll="ls -hlS"
    alias ld="echo 'Not found ld command.'"
    alias la="ls -a"
    alias lla="ls -ahlS"
  fi

  if is_linux; then
    if (($+commands[batcat])); then
      alias cat="batcat --style header,grid,changes"
    fi
  else
    if (($+commands[bat])); then
      alias cat="bat --style header,grid,changes"
    fi
  fi

  if is_exists gdate; then
    alias date="gdate"
  fi

  if (($+commands[kubectl])); then
    alias k="kubectl"
    alias kc="kubectl config current-context"
    alias ku="kubectl config use-context"
    alias kp="kubectl get pod"
  fi
}

: 'functions' && {
  fbr() {
    local branches=$(git branch -vv | fzf --prompt "[branch name]: " --query "$LBUFFER")
    if [[ -n "$branches" ]]; then
      BUFFER="git switch $(echo "$branches" | awk '{print $1}' | sed "s/.* //")"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N fbr

  ghq-fcd() {
    local selected_dir=$(ghq list -p | fzf --prompt "[repository]: " --preview 'bat --color always --style header,grid --line-range :100 {}/README.*' --query "$LBUFFER")
    if [[ -n "$selected_dir" ]]; then
      BUFFER="cd ${selected_dir}"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N ghq-fcd

  fzf-z-search() {
    local res=$(z | sort -rn | cut -c 12- | fzf)
    if [ -n "$res" ]; then
      BUFFER+="cd $res"
      zle accept-line
    else
      return 1
    fi
  }
  zle -N fzf-z-search

  zle -N step

  ec2_up() {
    aws ec2 start-instances --instance-ids $MY_DEV_INSTANCE_ID &&
    aws ec2 wait instance-running --instance-ids $MY_DEV_INSTANCE_ID &&
    aws ec2 wait instance-status-ok --instance-ids $MY_DEV_INSTANCE_ID &&
    sleep 180 &&
    echo "**Now instance is up**"
  }

  ec2_down() {
    aws ec2 stop-instances --instance-ids $MY_DEV_INSTANCE_ID &&
    aws ec2 wait instance-stopped --instance-ids $MY_DEV_INSTANCE_ID &&
    echo "**Now instance is down**"
  }

  select_worktree() {
    local worktrees
    worktrees=$(git worktree list --porcelain | awk '/worktree / {print $2}')
    if [[ -z "$worktrees" ]]; then
      echo "No worktrees found."
      return 1
    fi
    local selected
    selected=$(echo "$worktrees" | fzf)
    if [[ -n "$selected" ]]; then
      echo "$selected"
      cd "$selected"
    fi
  }
  zle -N select_worktree
}

: 'bindkeys' && {
  bindkey '^a' beginning-of-line
  bindkey '^b' backward-char
  bindkey '^e' end-of-line
  bindkey '^f' forward-char
  bindkey '^k' kill-line
  bindkey '^n' down-line-or-history
  bindkey '^p' up-line-or-history
  bindkey 'ƒ' forward-word # Option + f
  bindkey '∫' backward-word # Option + b

  bindkey 'ç' fzf-cd-widget # Option + c (override fzf ALT-C binding)
  bindkey '^g' ghq-fcd
  bindkey '^]' fbr
  bindkey '^z' fzf-z-search
  bindkey '^s' step
  bindkey '^w' select_worktree
}

: 'zinit plugins' && {
  zinit ice depth=1 atload"!source ~/.p10k.zsh"
  zinit light romkatv/powerlevel10k

  zinit ice wait lucid atload'_zsh_autosuggest_start'
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=248'; bindkey '^q' autosuggest-accept
  zinit light zsh-users/zsh-autosuggestions

  zinit ice wait lucid as"program" src"z.sh"
  zinit load "rupa/z"

  zinit ice wait'1' lucid
  zinit light zdharma-continuum/fast-syntax-highlighting

  zinit ice wait'2' lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

  zinit ice wait'2' lucid as"program" pick "contrib/completion/git-completion.zsh"
  zinit light git/git

  zinit ice wait'2' lucid as"program" pick"bin/git-dsf"
  zinit light zdharma-continuum/zsh-diff-so-fancy

  zinit ice wait'3' lucid as"program" pick"cli/contrib/completion/zsh/_docker" atload"export DOCKER_BUILDKIT=1"
  zinit light docker/cli

  zinit ice wait'3' lucid as"program" pick"compose/contrib/completion/zsh" atload"export COMPOSE_DOCKER_CLI_BUILD=1"
  zinit light docker/compose
}

: 'initialize completion' && {
  : 'for gh completion' && {
    if is_darwin; then
      # for M1
      if [[ "$(arch)" == "arm64" ]]; then
        GH_COMPLETION_PATH=/opt/homebrew/share/zsh/site-functions/_gh
      else
        GH_COMPLETION_PATH=/usr/local/share/zsh/site-functions/_gh
      fi

      if [ ! -f $GH_COMPLETION_PATH ]; then
        touch $GH_COMPLETION_PATH
        gh completion -s zsh > $GH_COMPLETION_PATH
      fi
    fi

  }

  autoload -U compinit && compinit

  : 'for awscli completion' && {
    autoload bashcompinit && bashcompinit
    AWS_COMPLETER_PATH=$(which aws_completer)
    complete -C ${AWS_COMPLETER_PATH}
  }

  : 'for kubectl completion' && {
    source <(kubectl completion zsh)
  }
}

. $HOME/.local_zshrc
