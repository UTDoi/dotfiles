export EDITOR='vim'
export VISUAL='less'
export PAGER='less'
export PATH=/usr/local/git/bin:$PATH:$HOME/.nodebrew/current/bin
export JAVA_HOME=`/usr/libexec/java_home -v 10`

: 'env vars for locale & timezone' && {
  export TZ='Asia/Tokyo'
  export LANGUAGE='ja_JP.UTF-8'
  export LANG=${LANGUAGE}
  export LC_ALL=${LANGUAGE}
  export LC_TYPE=${LANGUAGE}
}

