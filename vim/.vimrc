set runtimepath^=$HOME/.settings/vim
set runtimepath+=$HOME/.settings/vim/after
set viminfo+=n$HOME/.settings/vim/viminfo

filetype plugin indent off

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=$HOME/.settings/vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.settings/vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 " Note: You don't set neobundle setting in .gvimrc!
 NeoBundle 'altercation/vim-colors-solarized'
 NeoBundle 'alpaca-tc/alpaca_powertabline'
 "NeoBundle 'Lokaltog/powerline.git'
 NeoBundle 'nathanaelkane/vim-indent-guides'
 "NeoBundle 'apple-swift', {'type': 'nosync', 'base': '~/.settings/vim/bundle/swift-highlight'}
 NeoBundle 'Shougo/neocomplete'
 NeoBundle 'scrooloose/nerdtree'

 NeoBundle 'majutsushi/tagbar'
 NeoBundle 'szw/vim-tags'

 NeoBundle 'tpope/vim-endwise'

 "" markdownプレビュー
 NeoBundle 'plasticboy/vim-markdown'
 NeoBundle 'kannokanno/previm'
 NeoBundle 'tyru/open-browser.vim'

 "" python構文・コーディング規約チェック
 NeoBundle 'Flake8-vim'
 NeoBundle 'davidhalter/jedi-vim'
 NeoBundle 'hynek/vim-python-pep8-indent'

 "" HTML/CSS
 "NeoBundle 'amirh/HTML-AutoCloseTag'
 NeoBundle 'hail2u/vim-css3-syntax'
 NeoBundle 'gorodinskiy/vim-coloresque'
 NeoBundle 'mattn/emmet-vim'

 NeoBundle 'tpope/vim-surround'

 NeoBundle 'othree/yajs.vim'

 "" JSON syntax
 NeoBundle 'elzr/vim-json'

 NeoBundle 'leafgarland/typescript-vim'
 NeoBundle 'jason0x43/vim-js-indent'

call neobundle#end()

NeoBundleCheck

"*****************************************************************************
""" Abbreviations
"*****************************************************************************
""" NERDTree
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules', 'bower_components']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 30
let NERDTreeShowHidden=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

"" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif

"" emmet
let g:neocomplete#keyword_patterns._ = '\h\w*'
let g:user_emmet_leader_key='<c-e>'
let g:user_emmet_settings = {
            \    'variables': {
            \      'lang': "ja"
            \    },
            \   'indentation': '  '
            \ }

"******************
"" PyFlake
let g:PyFlakeOnWrite = 1
let g:PyFlakeCheckers = 'pep8,mccabe,pyflakes'
let g:PyFlakeDefaultComplexity=10
"******************

"
" Solarized
" 
set background=dark
colorscheme solarized

"
" Powerline
"
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set showtabline=2 "タブページを常に表示
set laststatus=2 "ステータスバーを表示
let g:Powerline_symbols = 'fancy'
set noshowmode

"
" Indent Guides
"
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=black
let g:indent_guides_start_level=1
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=1

"
" Option
"
syntax enable "シンタックスハイライト
set autoindent "改行時に前の行のインデントを継続する
set backspace=indent,eol,start "削除できない文字を削除できるように
set clipboard=unnamed,autoselect "OSのクリップボードと同期
set cursorline "入力行を強調表示
set encoding=UTF-8 "エンコードをUTF-8に
set expandtab "タブ入力を複数の空白入力に置き換える
set fileencoding=UTF-8 "ファイルのエンコードをUTF-8に
set hlsearch "検索結果をハイライト
set ignorecase smartcase "大文字小文字を区別しない（ただし大文字が検索文字列に含まれるときは区別
set incsearch "インクリメンタルサーチ
set list "不可視文字を表示
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲ "不可視文字置き換え
set number "行番号を表示
set ruler "カーソル位置を右下に表示
set scrolloff=5 "画面に常にに表示する行数
set shiftwidth=4 "自動インデントでずれる幅
set showcmd "入力中のコマンドを表示
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set softtabstop=4 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set tabstop=4 "画面上でタブ文字が占める幅
set termencoding=UTF-8 "ターミナルのエンコードをUTF-8に

"
" 関数
"
function FigletVim()
    let string=getline('.')
    if string == ""
        return
    endif
    let tmp = @a
    let @a = system("figlet " . string . " | sed 's/^\\(.\\)/\\/\\/ \\1/'")
    execute ":normal dd"
    execute 'normal "ap'
    let @a = tmp
endfunction

""""""""""
" Keymap "
"        "
""""""""""
"
" Normal
"
nnoremap <silent><C-/> :NERDTreeFind<CR>
nnoremap <silent><C-n> :NERDTreeToggle<CR>

"
" Insert
"
inoremap <C-_> :NERDTreeToggle<CR>

"
" Command
"
"
" 保存時にsudo権限で無理やり保存
cnoremap w!! w !sudo tee > /dev/null %<CR>

filetype plugin indent on
