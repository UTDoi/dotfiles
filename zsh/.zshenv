: 'locale & timezone' && {
  export TZ='Asia/Tokyo'
  export LANGUAGE='en_US.UTF-8'
  export LANG=${LANGUAGE}
  export LC_ALL=${LANGUAGE}
  export LC_TYPE=${LANGUAGE}
}

: 'editor & viewer' && {
  export EDITOR='nvim'
  export VISUAL='less'
  export PAGER='less'
}

: 'ls colors' && {
  : 'for BSD ls' && {
    export LSCOLORS=gxfxcxdxbxegedabagacad
  }
  : 'for GNU ls' && {
    export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  }
}

: "fzf configuration" && {
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_DEFAULT_OPTS='--height 60% --multi --reverse --border --ansi'
  export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'
  export FZF_ALT_C_OPTS="--select-1 --exit-0 --preview 'tree -C {} | head -200'"
}

: "aws saml login configuration" && {
  export AWS_PROFILE=saml
  export SAML2AWS_PROFILE=saml
}

: 'others' && {
  export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
  export LISTMAX=0
}
