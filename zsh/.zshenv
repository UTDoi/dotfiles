: 'locale & timezone' && {
  export TZ='Asia/Tokyo'
  export LANGUAGE='en_US.UTF-8'
  export LANG=${LANGUAGE}
  export LC_ALL=${LANGUAGE}
  export LC_TYPE=${LANGUAGE}
}

: 'editor & viewer' && {
  export EDITOR='vim'
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

: 'others' && {
  export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
  export LISTMAX=0
}
