let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowRelativePath=1
" let g:fzf_command_prefix='FZF'
let g:neomake_echo_current_error=0
let g:neomake_highlight_columns = 0
"let g:neomake_open_list = 2
let g:neomake_makeprg_remove_invalid_entries = 0
let g:neomake_place_signs = 0
let g:neomake_serialize = 1
let g:neomake_virtualtext_current_error=0
let g:omni_sql_no_default_maps = 1
let g:rooter_manual_only = 1
let g:rooter_patterns = ['Gemfile', 'Cargo.toml', '.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
let g:rooter_resolve_links = 1
let g:rooter_cd_cmd = 'lcd'
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_block_style = 'do'
let g:yankring_clipboard_monitor = 0
let g:yankring_history_file = '.cache/nvim/yankring_history'

if has('macunix')
  let g:yankring_replace_n_pkey = 'π' " option-p
  let g:yankring_replace_n_nkey = 'ø' " option-o
else
  let g:yankring_replace_n_pkey = '<A-p>' " option-p
  let g:yankring_replace_n_nkey = '<A-o>' " option-o
endif

let g:python_host_prog=$HOMEBREW_PREFIX . '/bin/python'
let g:python3_host_prog=$HOMEBREW_PREFIX . '/bin/python3'

let g:mundo_prefer_python3 = 1

let g:grep_cmd_opts = '--vimgrep --no-column'

let g:tagbar_autofocus = 1
let g:tagbar_type_dart = { 'ctagsbin': '~/.pub-cache/bin/dart_ctags' }
let g:tagbar_type_ruby = {
      \ 'ctagsbin': 'ripper-tags',
      \ 'ctagsargs': ['--tag-file', '-'],
      \ 'kinds': [ 'c:classes', 'f:methods', 'm:modules', 'F:singleton methods', 'C:constants', 'a:aliases' ]
      \ }
let g:tagbar_type_rust = {
      \ 'ctagstype' : 'rust',
      \ 'kinds' : [
      \ 'n:module',
      \ 's:structural type',
      \ 'i:trait interface',
      \ 'c:implementation',
      \ 'f:Function',
      \ 'g:Enum',
      \ 't:Type Alias',
      \ 'v:Global variable',
      \ 'M:Macro Definition',
      \ 'm:A struct field',
      \ 'e:An enum variant',
      \ 'P:A method',
      \ ]
      \ }

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

" Disable ale when opened with gem or bundler
if match($_, '\(bundle\|gem\)$') > 0
  let g:ale_enabled = 0
endif

" let g:ale_linters = { 'rust': ['cargo', 'rls'] } " \ 'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
let g:ale_linters = { 'rust': ['cargo'] } " \ 'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
let g:ale_linters_ignore = { 'ruby': ['solargraph'] }
let g:ale_fixers = { 'ruby': ['rubocop'], 'javascript': ['eslint', 'importjs', 'prettier'], 'rust': 'rustfmt' }
let g:ale_rust_cargo_avoid_whole_workspace = 0
let g:ale_rust_cargo_check_all_targets = 1
let g:ale_rust_cargo_check_examples = 1
" let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_use_clippy = 1
let g:ale_rust_rls_config = {'rust': {'clippy_preference': 'on'}}
let g:ale_rust_rls_toolchain = 'nightly'
" let g:ale_rust_rls_executable = 'ra_lsp_server'

" let g:diagnostic_enable_virtual_text = 1

let g:rust_use_custom_ctags_defs = 1
let g:rust_fold = 1
let g:rustfmt_options = '--edition 2018'

let g:surround_no_insert_mappings = 1

let g:racer_experimental_completer = 1
" let g:SuperTabDefaultCompletionType = "context"
" let g:mucomplete#chains = { 'default' : ['path', 'omni', 'incl', 'c-p', 'dict', 'uspl'], }
" let g:mucomplete#minimum_prefix_length = 0

let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '≥' " option->
let g:multi_cursor_select_all_word_key = 'µ' " option-m
let g:multi_cursor_start_key           = 'g≥' "g option->
let g:multi_cursor_select_all_key      = 'gµ' "g option-m
let g:multi_cursor_next_key            = '≥' " option->
let g:multi_cursor_prev_key            = '≤' " option-<
let g:multi_cursor_skip_key            = '÷' " option-/
let g:multi_cursor_quit_key            = '<Esc>'

let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'mermaid']

call plug#begin('~/.config/nvim/plugged')
" :sort /\v.{-}\//
Plug 'chrisbra/Colorizer'
Plug 'vim-scripts/YankRing.vim'
"Plug 'w0rp/ale'
Plug 'jlanzarotta/bufexplorer'
Plug 'chrisbra/csv.vim'
if has('macunix')
  " Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug '/home/linuxbrew/.linuxbrew/opt/fzf' | Plug 'junegunn/fzf.vim'
endif
Plug 'mdempsky/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'skwp/greplace.vim'
Plug 'udalov/kotlin-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'mracos/mermaid.vim'
Plug 'neomake/neomake'
"Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'chr4/nginx.vim'
" Plug 'norcalli/nvim-colorizer.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'keith/rspec.vim'
Plug 'ruby-formatter/rufo-vim'
"Plug 'rust-lang/rust.vim'
Plug 'ciaranm/securemodelines'
"Plug 'ervandew/supertab'
Plug 'keith/swift.vim'
Plug 'majutsushi/tagbar'
Plug 'junegunn/vader.vim'
Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'bazelbuild/vim-bazel' | Plug 'google/vim-maktaba'
Plug 'cstrahan/vim-capnp'
Plug 'kchmck/vim-coffee-script'
Plug 'sebdah/vim-delve'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'zchee/vim-flatbuffers'
" Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'michaeljsmith/vim-indent-object'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-markdown'
" Plug 'lifepillar/vim-mucomplete'
Plug 'terryma/vim-multiple-cursors'
Plug 'simnalamburt/vim-mundo'
Plug 'mustache/vim-mustache-handlebars'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'racer-rust/vim-racer'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user' | Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'christoomey/vim-tmux-navigator'
Plug 'cespare/vim-toml'
Plug 'tpope/vim-unimpaired'
Plug 'HerringtonDarkholme/yats.vim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'hrsh7th/nvim-compe'

"Plug 'iCyMind/NeoSolarized'
"Plug 'ayu-theme/ayu-vim'
"Plug 'joshdick/onedark.vim'
Plug 'lifepillar/vim-solarized8'
"Plug 'romainl/flattened'
"Plug 'rakr/vim-one'
"Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'morhetz/gruvbox'

for fork in split(globpath('~/.config/nvim/forked-plugins', '*'))
  Plug fork
endfor
call plug#end()

set termguicolors
set background=light
colorscheme solarized8_flat

set autoread
set backspace=indent,eol,start
set backupdir=.,$TMPDIR
set completeopt=menuone,noinsert
set copyindent
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cst
set expandtab sw=2 ts=2 sts=2
" set foldexpr=nvim_treesitter#foldexpr()
" set nofoldenable
" set foldlevel=2
" set foldmethod=expr
set formatoptions-=t
set grepprg=rg
set hidden " handle multiple buffers better
set history=1000
set inccommand=nosplit
set lazyredraw
set listchars=tab:>\ ,trail:·,nbsp:·,extends:>,precedes:<
set mouse=a
set nojoinspaces
set nolist
set noswapfile
set number
set numberwidth=3
set ruler
set shell=zsh
set shortmess+=c " Shut off completion messages
set showcmd
set showmatch " show matching parentheses
set smarttab
set ssop-=folds
set ssop-=options
set textwidth=120
set tildeop
set title
set undodir=~/.cache/nvim/undo
set undofile
set wildignore=*.swp,*.bak,*.pyc,*.class,*.png,*.o,*.jpg
set wildmenu " better tab completion for files
set wildmode=list:longest

" TODO statusline shows currenttag from the current buffer on all splits
let &statusline="%f%-m%-r %p%%:%l/%L Col:%vBuf:#%n Char:%b,0x%B"
      \ . "%{CurrentTag()}%{AleStatus()}"
let git_root = systemlist('git rev-parse --show-toplevel')[0]
if !empty(git_root)
  let &tags .= ',' . git_root . '/.git/tags'
endif

filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

if has('autocmd')
  autocmd FileType c setlocal sw=4 ts=8 nolist
  autocmd FileType dirvish call fugitive#detect(@%)
  autocmd FileType python setlocal expandtab sw=4 ts=4 sts=4

  " Show trailing whitepace and spaces before a tab:
  "autocmd Syntax * syn match Error /\s\+$\| \+\ze\t/

  autocmd BufRead,BufNewFile *.as set filetype=actionscript

  " Remove trailing whitespace on save if the file has no trailing whitespace
  " autocmd BufRead,BufNewFile *.{java,proto,rb,rs,erb,h,m,haml,js,html,coffee,json,vim} call s:TestStripTrailingWhitespace()

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif


  " :bd! doesn't seem to kill the process correctly
  "autocmd TermOpen * noremap <unique> <silent> <buffer> q :bd!<CR>
  autocmd User NeomakeJobFinished nested call s:NeomakeFinished()

  autocmd TermOpen * startinsert
  autocmd FileType rust if getline('$') =~ "vim-cargo-tests" | let b:ale_rust_cargo_check_tests = 1 | endif
  " autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
endif

" lua require 'colorizer'.setup()

let mapleader = "\<Space>"
" inoremap <unique> <C-g> <ESC>
" inoremap <unique> jk <ESC>
" inoremap jj <Esc>
" tmux-navigator maps the others
tnoremap <unique> <C-h> <C-\><C-N><C-w>h
tnoremap <unique> <C-j> <C-\><C-N><C-w>j
tnoremap <unique> <C-k> <C-\><C-N><C-w>k
tnoremap <unique> <C-l> <C-\><C-N><C-w>l
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
noremap <unique> / /\v
" noremap <unique> <C-E> 5<C-E>
" noremap <unique> <C-Y> 5<C-Y>
nnoremap <unique> - <C-W>-
nnoremap <unique> + <C-W>+
nnoremap <unique> <bar> <C-W><
nnoremap <unique> \ <C-W>>
" option-[
noremap <unique> “ :tabp<cr>
inoremap <unique> “ <ESC>:tabp<cr>
tnoremap <unique> “ <C-\><C-N>:tabp<cr>
noremap <unique> <A-[> :tabp<cr>
inoremap <unique> <A-[> <ESC>:tabp<cr>
tnoremap <unique> <A-[> <C-\><C-N>:tabp<cr>
" option-]
noremap <unique> ‘ :tabn<cr>
inoremap <unique> ‘ <ESC>:tabn<cr>
tnoremap <unique> ‘ <C-\><C-N>:tabn<cr>
noremap <unique> <A-]> :tabn<cr>
inoremap <unique> <A-]> <ESC>:tabn<cr>
tnoremap <unique> <A-]> <C-\><C-N>:tabn<cr>
" option-shift-[
noremap <unique> ” :tabm -1<cr>
inoremap <unique> ” <ESC>:tabm -1<cr>
tnoremap <unique> ” <C-\><C-N>:tabm -1<cr>
noremap <unique> <A-{> :tabm -1<cr>
inoremap <unique> <A-{> <ESC>:tabm -1<cr>
tnoremap <unique> <A-{> <C-\><C-N>:tabm -1<cr>
" option-shift-]
noremap <unique> ’ :tabm +1<cr>
inoremap <unique> ’ <ESC>:tabm +1<cr>
tnoremap <unique> ’ <C-\><C-N>:tabm +1<cr>
noremap <unique> <A-}> :tabm +1<cr>
inoremap <unique> <A-}> <ESC>:tabm +1<cr>
tnoremap <unique> <A-}> <C-\><C-N>:tabm +1<cr>

noremap <unique> [w :tabp<cr>
noremap <unique> ]w :tabn<cr>
noremap <unique> Q @@
noremap <silent> <unique> <C-n> :NextError<cr>
noremap <silent> <unique> <C-p> :PreviousError<cr>
noremap <silent> <unique> <leader>q :cope<cr>
" option-y = ¥ yankring show
noremap <silent> ¥ :YRShow<CR>
noremap <silent> <A-y> :YRShow<CR>
" option-shift-m = Â
noremap <silent> Â :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> Â :MultipleCursorsFind <C-R>/<CR>
noremap <silent> <A-M> :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> <A-M> :MultipleCursorsFind <C-R>/<CR>

noremap <unique> <leader>w :set wrap! wrap?<cr>
noremap <unique> <leader>l :set list! list?<cr>
"noremap <unique> <leader>md :!mkdir -p %:p:h<cr>
noremap <unique> <leader><space> :nohls<cr>
noremap <unique> <leader>ew :e <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>es :sp <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>y "+y
noremap <unique> <leader>p "+p
noremap <unique> <leader>P "+P
noremap <unique> <leader>o "*p
noremap <unique> <leader>O "*P
noremap <unique> gn <ESC>/\v^[<=>\|]{7}( .*\|$)<cr>

noremap <unique> <leader>b :ToggleBufExplorer<cr>
noremap <unique> <leader>t :TagbarToggle<cr>
noremap <unique> <leader>u :MundoToggle<cr>
noremap <unique> <leader>n :NERDTreeToggle<cr>
" noremap <unique> <leader>f :FZF<cr>
" noremap <unique> <leader>d :FZFBuffers<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>d <cmd>Telescope buffers<cr>
nnoremap <leader>c <cmd>Telescope live_grep<cr>
noremap <unique> <leader>x :let @+ = expand('%')<cr>
noremap <unique> <leader>X :let @+ = expand('%').':'.line('.')<cr>

noremap <unique> <leader>af :ALEFix<cr>
noremap <unique> <leader>at :ALEToggle<cr>
noremap <unique> <leader>al :ALELint<cr>
noremap <unique> <leader>an :ALENext<cr>
noremap <unique> <leader>ap :ALEPrevious<cr>
noremap <unique> <leader>ar :ALEReset<cr>
noremap <unique> <leader>ad :ALEDetail<cr>
noremap <unique> <leader>ag :ALEGoToDefinition<cr>
noremap <unique> <leader>ah :ALEHover<cr>

try
  call luaeval('require("setup")', exists('g:no_lsp') && g:no_lsp)

  noremap <unique> gD <cmd>lua vim.lsp.buf.declaration()<CR>
  noremap <unique> gd <cmd>lua vim.lsp.buf.definition()<CR>
  noremap <unique> K <cmd>lua vim.lsp.buf.hover()<CR>
  noremap <unique> gi <cmd>lua vim.lsp.buf.implementation()<CR>
  noremap <unique> gA <cmd>lua vim.lsp.buf.code_action()<CR>
  noremap <unique> <leader>k <cmd>lua vim.lsp.buf.signature_help()<CR>
  noremap <unique> <leader>D <cmd>lua vim.lsp.buf.type_definition()<CR>
  noremap <unique> gR <cmd>lua vim.lsp.buf.rename()<CR>
  noremap <unique> gr <cmd>lua vim.lsp.buf.references()<CR>
  noremap <unique> <leader>h <cmd>lua vim.diagnostic.show_line_diagnostics({show_header = false})<CR>
  noremap <unique> ]d <cmd>lua vim.diagnostic.goto_next({popup_opts = {show_header = false}})<CR>
  noremap <unique> [d <cmd>lua vim.diagnostic.goto_prev({popup_opts = {show_header = false}})<CR>

  inoremap <silent><expr> <Tab> v:lua.tab_complete()
  inoremap <silent><expr> <S-Tab> v:lua.s_tab_complete()
catch
  echom 'error in lua/setup.lua' . v:exception
endtry

noremap <silent> <unique> <leader>W :ToggleDiffIgnoreWhitespace<cr>
nnoremap <leader>g :call SearchInProject()<cr>
nnoremap <leader>G :call SearchWordInProject()<cr>
cnoreabbrev <expr> GT ((getcmdtype() is# ':' && getcmdline() is# 'GT')?('Gtabedit :'):('GT'))

" imap <C-Space> <Plug>(ale_complete)

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" See yankring-custom-maps
function! YRRunAfterMaps()
  noremap Y :<C-U>YRYankCount 'y$'<cr>
endfunction

"function! s:TestNeomake()
"  let cmd = 'echo -n .; sleep 0.1; echo .; sleep 0.1; echo -n .; sleep 0.1; echo .; sleep 0.1; echo -n ""; sleep 0.1; echo -n .; echo ""; echo ""'
"  let custom_maker = neomake#utils#MakerFromCommand(cmd)
"  let custom_maker.name = "test"
"  let custom_maker.remove_invalid_entries = 0
"  "let custom_maker.place_signs = 0
"  let custom_maker.errorformat = "%f:%l:%c:%m"
"  let enabled_makers =  [custom_maker]
"  call neomake#Make(0, enabled_makers) | echo "running: " . cmd
"endfunction
"command! -complete=file TestNeomake call s:TestNeomake()

command! NeomakeClear call neomake#CleanOldProjectSignsAndErrors() | call neomake#CleanOldFileSignsAndErrors()

function! s:GetArgsOrVisualSelection(args)
  if a:args != ''
    return a:args
  else
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
      return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return "'".join(lines, "\n")."'"
  endif
endfunction

function! s:Rg(file_mode, args)
  let needle = s:GetArgsOrVisualSelection(a:args)
  " ripgrip will incorrectly detect that stdin is available and try to search that, <&- closes it.
  let cmd = "rg --vimgrep ".needle. " <&-"
  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.errorformat = "%f:%l:%c:%m"
  let enabled_makers =  [custom_maker]
  call neomake#Make({'file_mode': a:file_mode, 'enabled_makers': enabled_makers}) | echom "running: " . cmd
endfunction
command! -bang -nargs=* -complete=file -range Rg call s:Rg(<bang>0, <q-args>)

function! s:RgFilesContaining(file_mode, args)
  let cmd = "rg -l ".a:args. " <&-"
  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.errorformat = "%f"
  let enabled_makers =  [custom_maker]
  call neomake#Make({'file_mode': a:file_mode, 'enabled_makers': enabled_makers}) | echom "running: " . cmd
endfunction
command! -bang -nargs=* -complete=file RgFilesContaining call s:RgFilesContaining(<bang>0, <q-args>)

function! s:RgFiles(file_mode, args)
  let cmd = "rg --files -g '".a:args."'"
  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.errorformat = "%f"
  let enabled_makers =  [custom_maker]
  call neomake#Make({'file_mode': a:file_mode, 'enabled_makers': enabled_makers}) | echom "running: " . cmd
endfunction
command! -bang -nargs=* -complete=file RgFiles call s:RgFiles(<bang>0, <q-args>)

function s:NeomakeFinished() abort
  if g:neomake_hook_context.jobinfo.file_mode
    lope
  else
    cope
  end
  normal gg
endfunction

" From http://vim.wikia.com/wiki/Capture_ex_command_output
" Captures ex command and puts it in a new tab
function! s:TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call s:TabMessage(<q-args>)

" Linters
function! s:XMLlint(line1, line2)
  execute a:line1.",".a:line2." !xmllint --format --recover -"
endfunction
command! -range=% XMLlint call s:XMLlint(<line1>, <line2>)

" json_reformt is part of yajl
function! s:JSONlint(line1, line2)
  execute a:line1.",".a:line2." !json_reformat"
endfunction
command! -range=% JSONlint call s:JSONlint(<line1>, <line2>)

" Set ts sts sw = num
function! s:Tabs(num)
  let &tabstop = a:num
  let &shiftwidth = a:num
  let &softtabstop = a:num
  set ts? sw? sts?
endfunction
command! -nargs=1 -complete=command Tabs call s:Tabs(<args>)

function! s:LargeFile(echo)
  filetype off
  set filetype=text
  set inccommand=""
  set noincsearch
  set nonumber
  if a:echo
    set ft? incsearch? number?
  endif
endfunction
command! -bang LargeFile call s:LargeFile(<bang>1)

function! s:LargeFileOff()
  filetype on
  filetype detect
  set incsearch
  set number
  set ft? incsearch? number?
endfunction
command! LargeFileOff call s:LargeFileOff()

function! SynStack()
  let s:syn_stack = ''
  for id in synstack(line("."), col("."))
    let s:syn_stack = s:syn_stack . ' > ' . synIDattr(id, "name")
  endfor
  echo s:syn_stack
  return s:syn_stack
endfunction

function! s:ShowSynStack()
  let g:old_statusline = &statusline
  let g:old_laststatus = &laststatus
  set statusline+=%{SynStack()}
  set laststatus=2
endfunction
command! ShowSynStack call s:ShowSynStack()

function! s:HideSynStack()
  let &statusline=g:old_statusline
  let &laststatus=g:old_laststatus
endfunction
command! HideSynStack call s:HideSynStack()

function! CurrentTag() abort
  if &filetype != 'text'
    return tagbar#currenttag(' %s','','f')
  endif
endfunction

function! AleStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  let l:status = ''

  if all_errors > 0
    let l:status .= printf('  E:%d', all_errors)
  endif
  if all_non_errors > 0
    let l:status .= printf('  W:%d', all_non_errors)
  endif
  return status
endfunction

" Send the range to specified shell command's standard input
function! s:SendToCommand(UserCommand) range
  let SelectedLines = getline(a:firstline,a:lastline)
  " Convert to a single string suitable for passing to the command
  let ScriptInput = join(SelectedLines, "\n") . "\n"
  " Run the command
  echo system(a:UserCommand, ScriptInput)
endfunction
command! -complete=command -range -nargs=1 SendToCommand <line1>,<line2>call s:SendToCommand(<q-args>)

" Run the range as a shell command
function! s:RunCommand() range
  let pos = getpos(".")
  let selected_lines = getline(a:firstline,a:lastline)
  let cmd = join(selected_lines, "\n")
  call neomake#Sh(cmd)
  call setpos(".", pos)
endfunction
command! -range RunCommand <line1>,<line2>call s:RunCommand()
map <unique> <leader>! :RunCommand<cr>

function! s:TestStripTrailingWhitespace()
  if search('\s\+$', "cnw", 0, 500)
    autocmd BufWritePre <buffer> StripTrailingWhitespace
  endif
endfunction

function! s:StripTrailingWhitespace() range
  if line("'<")
    let pos = "'<,'>"
  else
    let pos = '.'
  endif
  let _s=@/ | exe "keepj normal! msHmt" | exe 'keepj '.pos.'s/\s\+$//e' | let @/=_s | nohl | exe "keepj normal! 'tzt`s"
endfunction
command! -range=% StripTrailingWhitespace <line1>,<line2>call s:StripTrailingWhitespace()

function! s:ToggleDiffIgnoreWhitespace()
  if match(&diffopt, 'iwhite') == -1
    set diffopt+=iwhite
  else
    set diffopt-=iwhite
  endif
  set diffopt?
endfunction
command! ToggleDiffIgnoreWhitespace call s:ToggleDiffIgnoreWhitespace()

function SearchInProject()
  let word = expand("<cword>")
  let @/='\v'.word
  set hls
  call s:Rg(0, word)
endfunction

function SearchWordInProject()
  let word = expand("<cword>")
  let @/='\v<' . word . '>'
  set hls
  call s:Rg(0, '--word-regexp '.word)
endfunction

let s:next_error_loclist = 0

function! s:NextError()
  try
    if s:next_error_loclist
      lbelow
    else
      try
        cbelow
      catch
        cnext
      endtry
    endif
  catch
  endtry
endfunction
command! NextError call s:NextError()

function! s:PreviousError()
  try
    if s:next_error_loclist
      labove
    else
      " cabove doesn't seem to throw an error when there are no errors above
      cprevious
    endif
  catch
  endtry
endfunction
command! PreviousError call s:PreviousError()

function! s:ToggleError()
  let s:next_error_loclist = !s:next_error_loclist
endfunction
command! ToggleError call s:ToggleError()

function! s:CI()
  execute '!' . $CI_COMMAND
endfunction
command! CI call s:CI()

" function s:LSPReset()
"   update
"   call luaeval('vim.lsp.stop_client(vim.lsp.get_active_clients())')
"   edit
" endfunction
" command! -complete=command LSPReset call s:LSPReset()
