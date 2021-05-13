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

: 'others' && {
  export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
}
