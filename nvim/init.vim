let s:dein_dir = expand($XDG_CACHE_HOME.'/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath+=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml      = expand($XDG_CONFIG_HOME.'/nvim/dein.toml')
  let s:lazy_toml = expand($XDG_CONFIG_HOME.'/nvim/dein_lazy.toml')

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable

" set options
set number
set autochdir
set encoding=utf-8
set fileencodings=utf-8,cp932
set clipboard+=unnamed,unnamedplus
set noswapfile
set autoread
set hidden
set cursorline
set smartindent
set visualbell
set virtualedit=onemore
set showmatch
set laststatus=2
set expandtab
set tabstop=2
set shiftwidth=2
set noshowmode

inoremap <silent> jj <Esc>
nmap <Esc><Esc> :nohlsearch<CR><Esc>
nmap wj <C-w>j
nmap wk <C-w>k
nmap wh <C-w>h
nmap wl <C-w>l

nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>

colorscheme iceberg
