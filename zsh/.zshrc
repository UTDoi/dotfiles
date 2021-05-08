if [[ ! -d ~/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

source ~/.zinit/bin/zinit.zsh

eval "$(anyenv init -)"
eval "$(direnv hook zsh)"

alias gcinolint='SKIP_ESLINT=1 git ci'
alias zshrc='~/dotfiles/.zshrc'
alias zprofile='~/dotfiles/.zprofile'
alias zpreztorc='~/dotfiles/.zpreztorc'
alias desk='cd ~/Desktop'
alias caco='cat ~/.zshrc'
alias gitlog='git log --oneline --left-right'
alias gidima='gitlog master...'
alias gidide='gitlog develop...'
alias gip='git push origin HEAD'
alias lint='npm run eslint-fix'
alias fspec='SKIP_SEED=1 bin/rspec'
alias rubocop='bundle ex rubocop -a'
alias gip='git push origin HEAD'
alias gipf='git push -f origin HEAD'
alias k='kubectl'

function lintall ()
{
  for jsfile in $(git st | awk '{print $2}' | grep -E '^front/javascripts/components/.+\.js$')
  do
      lint $jsfile
  done
}

autoload -U compinit
compinit

# 移動したディレクトリを記録しておく
setopt auto_pushd

# キーバインドをvi
# 補完候補が複数ある時に一覧を表示する
setopt auto_list

# 保管結果を詰める
setopt list_packed

# Tabで順に補完候補を自動で補完する
setopt auto_menu

# カッコなどを自動的に補完する
setopt auto_param_keys

# ディレクトリ名の補完で末尾のスラッシュを付加して次の補完に備える
setopt auto_param_slash

# 自動修正機能を有効
setopt correct

# 音鳴らさない
setopt nolistbeep

#Git用のタブ補完
autoload -Uz compinit && compinit

#Pure promptを適用
autoload -U promptinit; promptinit
prompt pure

# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify

# ヒストリ拡張
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# ヒストリを重複させない
setopt hist_ignore_dups     # ignore duplication command history list
# ヒストリを共有する
setopt share_history        # share command history data

# peco (brew install peco)
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
# 履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
