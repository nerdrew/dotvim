let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowRelativePath=1
"let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'
let g:fzf_command_prefix='FZF'
let g:neomake_makeprg_remove_invalid_entries = 0
let g:neomake_open_list = 1
let g:neomake_serialize = 1
let g:racer_cmd="racer"
let g:syntastic_auto_loc_list = 0
let g:syntastic_html_tidy_ignore_errors=['proprietary attribute "ng-', 'is not recognized!']
let g:yankring_clipboard_monitor = 0
let g:yankring_history_file = '.vim_yankring_history'

call plug#begin('~/.vim/plugged')
" :sort /\v.{-}\//
Plug 'mustache/vim-mustache-handlebars'
Plug 'vim-scripts/YankRing.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'chrisbra/csv.vim'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'ciaranm/securemodelines'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'cstrahan/vim-capnp'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'jnwhiteh/vim-golang'
Plug 'michaeljsmith/vim-indent-object'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-markdown'
Plug 'simnalamburt/vim-mundo'
Plug 'racer-rust/vim-racer'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user' | Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'cespare/vim-toml'

for fork in split(globpath('~/.vim/forked-plugins', '*'))
  Plug fork
endfor
call plug#end()

set backspace=indent,eol,start
set backupdir=.,$TMPDIR
set copyindent
set cscopequickfix=s-,c-,d-,i-,t-,e-
set csre
set expandtab sw=2 ts=2 sts=2
set hidden " handle multiple buffers better
set history=1000
set listchars=tab:>\ ,trail:·,nbsp:·,extends:>,precedes:<
set nolist
set noswapfile
set number
set numberwidth=3
set ruler
set showcmd
set showmatch " show matching parentheses
set ssop-=folds
set ssop-=options
set wildignore=*.swp,*.bak,*.pyc,*.class,*.png,*.o,*.jpg
set wildmenu " better tab completion for files
set wildmode=list:longest

set statusline=%f\ %m\ %r
set statusline+=Line:%l/%L[%p%%]
set statusline+=Col:%v
set statusline+=Buf:#%n
set statusline+=[%b][0x%B]
set statusline+=%{SyntasticStatuslineFlag()}

filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

if has('autocmd')
  autocmd filetype python setlocal expandtab sw=4 ts=4 sts=4
  autocmd filetype c setlocal sw=4 ts=8 nolist
  autocmd FileType go autocmd BufWritePre <buffer> GoFmt

  " Show trailing whitepace and spaces before a tab:
  "autocmd Syntax * syn match Error /\s\+$\| \+\ze\t/

  autocmd BufRead,BufNewFile *.as set filetype=actionscript

  " Remove trailing whitespace on save
  autocmd BufWritePre *.{java,proto,rb,rs,erb,h,m,haml,js,html,coffee,json} StripTrailingWhitespace

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
endif

noremap / /\v
noremap <C-e> 3<C-e>
noremap <C-y> 3<C-y>
nnoremap - <C-w>-
nnoremap + <C-w>+
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap “ :tabp<cr> " alt-[
noremap ‘ :tabn<cr> " alt-]
noremap ” :tabm -1<cr> " alt-shift-[
noremap ’ :tabm +1<cr> " alt-shift-]
noremap <C-@> @@

noremap <unique> <leader>w :set wrap! wrap?<cr>
noremap <unique> <leader>l :set list! list?<cr>
noremap <unique> <leader>md :!mkdir -p %:p:h<cr>
noremap <unique> <leader><space> :nohls<cr>
noremap <unique> <leader>ew :e <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>es :sp <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
noremap <unique> <leader>b :ToggleBufExplorer<cr>
noremap <unique> <leader>y "+y
noremap <unique> <leader>p "+p
noremap <unique> <leader>P "+P
"noremap <leader>gn <ESC>/\v^[<=>\|]{7}( .*\|$)<cr>

noremap <unique> <leader>t :TagbarToggle<cr>
noremap <unique> <leader>g :GundoToggle<cr>
noremap <unique> <leader>n :NERDTreeToggle<cr>
noremap <unique> <leader>f :FZF<cr>
noremap <unique> <leader>d :FZFBuffers<cr>
nmap <C-\> :call CscopeForTermUnderCursor()<cr>

" See yankring-custom-maps
function! YRRunAfterMaps()
  noremap Y :<C-U>YRYankCount 'y$'<CR>
endfunction

function! s:Ag(file_mode, args)
  let cmd = "ag --vimgrep --smart-case ".substitute(a:args, '\\', '\\\\', 'g')
  let custom_maker = neomake#utils#MakerFromCommand('bash', cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.place_signs = 0
  let enabled_makers =  [custom_maker]
  call neomake#Make({'enabled_makers': enabled_makers, 'file_mode': a:file_mode}) | echo "running: " . cmd
endfunction
command! -bang -nargs=* -complete=file Ag call s:Ag(<bang>0, <q-args>)

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
  set ft? incsearch?
endfunction
command! -complete=command LargeFile call s:LargeFile()

function! s:LargeFileOff()
  filetype on
  filetype detect
  set incsearch
  set ft? incsearch?
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

function! s:StripTrailingWhitespace(line1, line2)
  let _s=@/ | exe "normal! msHmt" | exe 'keepj '.a:line1.",".a:line2.'s/\s\+$//e' | let @/=_s | nohl | exe "normal! 'tzt`s"
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
  echo 'cscope find type (d=called/c=calling/g=definition/s=symbol/t=text/q=quit): '
  while index(validTypes, type) == -1
    let type = nr2char(getchar())
    if index(quitTypes, type) >= 0
      return
    endif
  endwhile
  let search = expand('<cword>')
  call inputrestore()
  execute 'cs find '.type.' '.search
endfunction
