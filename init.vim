"let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'
"let g:neomake_logfile = '/Users/lazarus/.config/nvim/neomake.log'
"let g:neomake_verbose = 3
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowRelativePath=1
let g:fzf_command_prefix='FZF'
let g:grep_cmd_opts = '--smart-case'
let g:neomake_highlight_columns = 0
let g:neomake_makeprg_remove_invalid_entries = 0
let g:neomake_place_signs = 0
let g:neomake_serialize = 1
let g:omni_sql_no_default_maps = 1
let g:racer_cmd = "racer"
let g:rooter_manual_only = 1
let g:rooter_patterns = ['Gemfile', 'Cargo.toml', '.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
let g:rooter_resolve_links = 1
let g:rooter_use_lcd = 1
let g:ruby_indent_assignment_style = 'variable'
let g:rust_fold = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_html_tidy_ignore_errors=['proprietary attribute "ng-', 'is not recognized!']
"let g:syntastic_go_checkers = ['golint', 'govet', 'gometalinter']
"let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:yankring_clipboard_monitor = 0
let g:yankring_history_file = '.vim_yankring_history'
let g:tagbar_autofocus = 1
let g:tagbar_type_ruby = { 'kinds': [ 'c:classes', 'f:methods', 'm:modules', 'F:singleton methods', 'C:constants', 'a:aliases' ] }
"let g:tagbar_type_ruby = { 'kinds': [ 'c:classes', 'f:methods', 'm:modules', 'F:singleton methods', 'C:constants', 'a:aliases' ], 'ctagsbin': 'ripper-tags', 'ctagsargs': [] }
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
"let g:ale_completion_enabled = 1
let g:ale_lint_delay = 2000 " wait 2s before linting after a change

call plug#begin('~/.vim/plugged')
" :sort /\v.{-}\//
Plug 'vim-scripts/YankRing.vim'
Plug 'w0rp/ale'
Plug 'jlanzarotta/bufexplorer'
Plug 'chrisbra/csv.vim'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'skwp/greplace.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'chr4/nginx.vim'
Plug 'rust-lang/rust.vim'
Plug 'ciaranm/securemodelines'
Plug 'ervandew/supertab'
Plug 'keith/swift.vim'
Plug 'majutsushi/tagbar'
Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'cstrahan/vim-capnp'
Plug 'kchmck/vim-coffee-script'
Plug 'sebdah/vim-delve'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'michaeljsmith/vim-indent-object'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-markdown'
Plug 'simnalamburt/vim-mundo'
Plug 'mustache/vim-mustache-handlebars'
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
"Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'

for fork in split(globpath('~/.config/nvim/forked-plugins', '*'))
  Plug fork
endfor
call plug#end()

set backspace=indent,eol,start
set backupdir=.,$TMPDIR
set copyindent
set completeopt=menu,preview,noinsert
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cst
set expandtab sw=2 ts=2 sts=2
set grepprg=rg\ -n
set hidden " handle multiple buffers better
set history=1000
set listchars=tab:>\ ,trail:·,nbsp:·,extends:>,precedes:<
set mouse=a
set nolist
set noswapfile
set number
set numberwidth=3
set ruler
set shell=zsh
set showcmd
set showmatch " show matching parentheses
set ssop-=folds
set ssop-=options
let &statusline="%f%-m%-r %p%%:%l/%L Col:%vBuf:#%n Char:%b,0x%B"
      \ . "%{tagbar#currenttag(' %s','','f')}%{AleStatus()}"
set tags+=.git/tags
set title
"set termguicolors
set wildignore=*.swp,*.bak,*.pyc,*.class,*.png,*.o,*.jpg
set wildmenu " better tab completion for files
set wildmode=list:longest

filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

if has('autocmd')
  autocmd FileType c setlocal sw=4 ts=8 nolist
  autocmd FileType dirvish call fugitive#detect(@%)
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType python setlocal expandtab sw=4 ts=4 sts=4

  " Show trailing whitepace and spaces before a tab:
  "autocmd Syntax * syn match Error /\s\+$\| \+\ze\t/

  autocmd BufRead,BufNewFile *.as set filetype=actionscript

  " Remove trailing whitespace on save if the file has no trailing whitespace
  autocmd BufRead,BufNewFile *.{java,proto,rb,rs,erb,h,m,haml,js,html,coffee,json,vim} call s:TestStripTrailingWhitespace()

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif

  autocmd BufReadPost quickfix nnoremap <silent> <buffer> <leader>h <C-W><cr><C-W>K
        \| nnoremap <silent> <buffer> <leader>H <C-W><cr><C-W>K<C-W>b
        \| nnoremap <silent> <buffer> q :ccl<cr>
        \| nnoremap <silent> <buffer> <leader>t <C-W><cr><C-W>T
        \| nnoremap <silent> <buffer> <leader>T <C-W><cr><C-W>TgT<C-W><C-W>
        \| nnoremap <silent> <buffer> <leader>v <C-W><cr><C-W>H<C-W>b<C-W>J<C-W>t

  " :bd! doesn't seem to kill the process correctly
  "autocmd TermOpen * noremap <unique> <silent> <buffer> q :bd!<CR>
endif

let mapleader = "\<Space>"
" tmux-navigator maps the others
tnoremap <unique> <C-h> <C-\><C-N><C-w>h
tnoremap <unique> <C-j> <C-\><C-N><C-w>j
tnoremap <unique> <C-k> <C-\><C-N><C-w>k
tnoremap <unique> <C-l> <C-\><C-N><C-w>l
noremap <unique> / /\v
noremap <unique> <C-E> 3<C-E>
noremap <unique> <C-Y> 3<C-Y>
nnoremap <unique> - <C-W>-
nnoremap <unique> + <C-W>+
nnoremap <unique> <bar> <C-W><
nnoremap <unique> \ <C-W>>
" alt-[
noremap <unique> “ :tabp<cr>
inoremap <unique> “ <ESC>:tabp<cr>
tnoremap <unique> “ <C-\><C-N>:tabp<cr>
" alt-]
noremap <unique> ‘ :tabn<cr>
inoremap <unique> ‘ <ESC>:tabn<cr>
tnoremap <unique> ‘ <C-\><C-N>:tabn<cr>
" alt-shift-[
noremap <unique> ” :tabm -1<cr>
inoremap <unique> ” <ESC>:tabm -1<cr>
tnoremap <unique> ” <C-\><C-N>:tabm -1<cr>
" alt-shift-]
noremap <unique> ’ :tabm +1<cr>
inoremap <unique> ’ <ESC>:tabm +1<cr>
tnoremap <unique> ’ <C-\><C-N>:tabm +1<cr>

noremap <unique> [w :tabp<cr>
noremap <unique> ]w :tabn<cr>
noremap <unique> <C-@> @@

noremap <unique> <leader>w :set wrap! wrap?<cr>
noremap <unique> <leader>l :set list! list?<cr>
"noremap <unique> <leader>md :!mkdir -p %:p:h<cr>
noremap <unique> <leader><space> :nohls<cr>
noremap <unique> <leader>ew :e <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>es :sp <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>b :ToggleBufExplorer<cr>
noremap <unique> <leader>y "+y
noremap <unique> <leader>p "+p
noremap <unique> <leader>P "+P
noremap <unique> gn <ESC>/\v^[<=>\|]{7}( .*\|$)<cr>

noremap <unique> <leader>t :TagbarToggle<cr>
noremap <unique> <leader>u :MundoToggle<cr>
noremap <unique> <leader>n :NERDTreeToggle<cr>
noremap <unique> <leader>f :FZF<cr>
noremap <unique> <leader>d :FZFBuffers<cr>
noremap <unique> <leader>x :let @+ = expand('%')<cr>
noremap <unique> <leader>X :let @+ = expand('%').':'.line('.')<cr>

noremap <leader>] :call CscopeForTermUnderCursor()<cr>

if filereadable(".git/cscope.out")
  execute "cs add .git/cscope.out"
endif

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

function! s:Rg(file_mode, args)
  let cmd = "rg --vimgrep ".a:args
  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.errorformat = "%f:%l:%c:%m"
  let enabled_makers =  [custom_maker]
  call neomake#Make({'file_mode': a:file_mode, 'enabled_makers': enabled_makers}) | echo "running: " . cmd
endfunction
command! -bang -nargs=* -complete=file G call s:Rg(<bang>0, <q-args>)

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
command! -range=% -complete=command XMLlint call s:XMLlint(<line1>, <line2>)

" json_reformt is part of yajl
function! s:JSONlint(line1, line2)
  execute a:line1.",".a:line2." !json_reformat"
endfunction
command! -range=% -complete=command JSONlint call s:JSONlint(<line1>, <line2>)

" Set ts sts sw = num
function! s:Tabs(num)
  let &tabstop = a:num
  let &shiftwidth = a:num
  let &softtabstop = a:num
  set ts? sw? sts?
endfunction
command! -nargs=1 -complete=command Tabs call s:Tabs(<args>)

function! s:LargeFile()
  filetype off
  set filetype=text
  set noincsearch
  set nonumber
  set ft? incsearch? number?
endfunction
command! -complete=command LargeFile call s:LargeFile()

function! s:LargeFileOff()
  filetype on
  filetype detect
  set incsearch
  set number
  set ft? incsearch? number?
endfunction
command! -complete=command LargeFileOff call s:LargeFileOff()

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
command! -complete=command ShowSynStack call s:ShowSynStack()

function! s:HideSynStack()
  let &statusline=g:old_statusline
  let &laststatus=g:old_laststatus
endfunction
command! -complete=command HideSynStack call s:HideSynStack()

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
  let RunCommandCursorPos = getpos(".")
  let SelectedLines = getline(a:firstline,a:lastline)
  " Convert to a single string suitable for passing to the command
  let ScriptInput = join(SelectedLines, " ") . "\n"
  echo system(ScriptInput)
  call setpos(".", RunCommandCursorPos)
endfunction
command! -complete=command -range RunCommand <line1>,<line2>call s:RunCommand()
map <unique> <leader>! :RunCommand<cr>

function! s:TestStripTrailingWhitespace()
  if !search('\s\+$', "cnw", 0, 500)
    autocmd BufWritePre <buffer> StripTrailingWhitespace
  endif
endfunction

function! s:StripTrailingWhitespace(line1, line2)
  let _s=@/ | exe "keepj normal! msHmt" | exe 'keepj '.a:line1.",".a:line2.'s/\s\+$//e' | let @/=_s | nohl | exe "keepj normal! 'tzt`s"
endfunction
command! -range=% -complete=command StripTrailingWhitespace call s:StripTrailingWhitespace(<line1>, <line2>)

function! s:ToggleDiffIgnoreWhitespace()
  if match(&diffopt, 'iwhite') == -1
    set diffopt+=iwhite
  else
    set diffopt-=iwhite
  endif
  set diffopt?
endfunction
command! -complete=command ToggleDiffIgnoreWhitespace call s:ToggleDiffIgnoreWhitespace()
noremap <silent> <unique> <leader>W :ToggleDiffIgnoreWhitespace<cr>

function! CscopeForTermUnderCursor()
  call inputsave()
  let type = ''
  let validTypes = ['d', 'c', 'g', 's', 't']
  let quitTypes = ['q', '', '']
  echo 'cscope find <type> (d=called/c=calling/g=definition/s=symbol/t=text/q=quit): '
  while index(validTypes, type) == -1
    let type = nr2char(getchar())
    if index(quitTypes, type) >= 0
      redraw!
      return
    endif
  endwhile
  let search = expand('<cword>')
  call inputrestore()
  execute 'cs find '.type.' '.search
endfunction

function SearchInProject()
  let word = expand("<cword>")
  let @/='\v'.word
  set hls
  exec "G " . word
endfunction

function SearchWordInProject()
  let word = expand("<cword>")
  let @/='\v<' . word . '>'
  set hls
  exec "G --word-regexp " . word . ""
endfunction
nnoremap <leader>g :call SearchInProject()<cr>
nnoremap <leader>G :call SearchWordInProject()<cr>
