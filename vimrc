let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowRelativePath=1
let g:neomake_makeprg_remove_invalid_entries = 0
let g:neomake_open_list = 1
let g:neomake_serialize = 1
let g:racer_cmd="./target/release/racer"
let g:syntastic_html_tidy_ignore_errors=['proprietary attribute "ng-', 'is not recognized!']
let g:yankring_clipboard_monitor = 0
let g:yankring_history_file = '.vim_yankring_history'

call plug#begin('~/.vim/plugged')
Plug 'cespare/vim-toml'
Plug 'chrisbra/csv.vim'
Plug 'ciaranm/securemodelines'
Plug 'cstrahan/vim-capnp'
Plug 'ervandew/supertab'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'fatih/vim-go'
Plug 'jlanzarotta/bufexplorer'
Plug 'jnwhiteh/vim-golang'
Plug 'kana/vim-textobj-user' | Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'majutsushi/tagbar'
Plug 'michaeljsmith/vim-indent-object'
Plug 'pangloss/vim-javascript'
Plug 'phildawes/racer', { 'do': 'cargo build --release' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/YankRing.vim'

" Forked plugins
Plug '~/.vim/forked-plugins/dart-vim-plugin'
Plug '~/.vim/forked-plugins/greplace.vim'
Plug '~/.vim/forked-plugins/neomake'
Plug '~/.vim/forked-plugins/rust.vim'
Plug '~/.vim/forked-plugins/syntastic'
Plug '~/.vim/forked-plugins/vim-addon-local-vimrc'
call plug#end()

set mouse=a
set guifont=Menlo:h11
set showmatch       " show matching parentheses
set hidden          " handle multiple buffers better
set wildmenu        " better tab completion for files
set wildmode=list:longest
set wildignore=*.swp,*.bak,*.pyc,*.class,*.png,*.o,*.jpg
set history=1000
set ruler
set backspace=indent,eol,start
set copyindent
set listchars=tab:>\ ,trail:·,nbsp:·,extends:>,precedes:<
set nolist
set noswapfile
set ssop-=options
set ssop-=folds
set csre
set cscopequickfix=s-,c-,d-,i-,t-,e-
set showcmd
set numberwidth=3
set number

set statusline=%f\ %m\ %r
set statusline+=Line:%l/%L[%p%%]
set statusline+=Col:%v
set statusline+=Buf:#%n
set statusline+=[%b][0x%B]
set statusline+=%{SyntasticStatuslineFlag()}

if has('autocmd')
  autocmd filetype python setlocal expandtab sw=4 ts=4 sts=4
  autocmd filetype ruby,eruby,yaml setlocal expandtab sw=2 ts=2 sts=2
  autocmd filetype c setlocal sw=4 ts=8 nolist
  autocmd FileType go autocmd BufWritePre <buffer> GoFmt

  " Show trailing whitepace and spaces before a tab:
  "autocmd Syntax * syn match Error /\s\+$\| \+\ze\t/

  " eruby doesn't correctly indent javascript w/o this
  "autocmd BufRead,BufNewFile *.html.erb set filetype=javascript
  "autocmd BufRead,BufNewFile *.html.erb set filetype=eruby.html
  "autocmd BufRead,BufNewFile *.js.erb set filetype=eruby.javascript

  autocmd BufRead,BufNewFile *.as set filetype=actionscript

  " Remove trailing whitespace on save
  autocmd BufWritePre *.{java,proto,rb,erb,h,m,haml,js,html,coffee,json} StripTrailingWhitespace
endif

"""""""""""""""""""""""""""""""""
" Keyboard mappings
"""""""""""""""""""""""""""""""""
nnoremap / /\v
vnoremap / /\v
nnoremap Y y$
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" alt-[
noremap “ :tabp<CR>
" alt-]
noremap ‘ :tabn<CR>
" alt-shift-[
noremap ” :tabm -1<CR>
" alt-shift-]
noremap ’ :tabm +1<CR>

" unmap stupid janus
" unmap <leader>fc
" unmap <leader>fef
" unmap <leader>tw
" unmap <leader>gb
" unmap <leader>gs
" unmap <leader>gd
" unmap <leader>gl
" unmap <leader>gc
" unmap <leader>gp
" unmap <leader>rt

noremap <unique> <leader>w :set wrap! wrap?<CR>
noremap <unique> <leader>g :GundoToggle<CR>
noremap <unique> <leader>n :NERDTreeToggle<CR>
noremap <unique> <leader>l :set list! list?<cr>
noremap <unique> <leader>t :TagbarToggle<CR>
noremap <unique> <leader>f :FZF<CR>
nnoremap <unique> <leader>b :ToggleBufExplorer<CR>
noremap <leader><space> :nohls<cr>
vnoremap <unique> <leader>y "+y
"noremap <leader>gn <ESC>/\v^[<=>\|]{7}( .*\|$)<CR>
noremap <C-@> @@
nmap <C-\> :call CscopeForTermUnderCursor()<CR>

function! s:Ag(file_mode, args)
  let cmd = "ag --vimgrep --smart-case ".a:args
  let custom_maker = neomake#utils#MakerFromCommand(&shell, cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.place_signs = 0
  let enabled_makers =  [custom_maker]
  call neomake#Make({'enabled_makers': enabled_makers, 'file_mode': a:file_mode}) | echo "running: " . cmd
endfunction

command! -bang -nargs=* -complete=file Ag call s:Ag(<bang>1, <q-args>)

" From http://vim.wikia.com/wiki/Capture_ex_command_output
" Captures ex command and puts it in a new tab
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  tabnew
  silent put=message
  set nomodified
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)


" Linters
function! XMLlint(line1, line2)
  execute a:line1.",".a:line2." !xmllint --format --recover -"
endfunction
command! -range=% -complete=command XMLlint call XMLlint(<line1>, <line2>)

function! JSONlint(line1, line2)
  execute a:line1.",".a:line2." !json_reformat"
endfunction
command! -range=% -complete=command JSONlint call JSONlint(<line1>, <line2>)


" Set ts sts sw = num
function! Tabs(num)
  let &tabstop = a:num
  let &shiftwidth = a:num
  let &softtabstop = a:num
  set ts? sw? sts?
endfunction
command! -nargs=1 -complete=command Tabs call Tabs(<args>)

function! LargeFile()
  filetype off
  set filetype=text
  set noincsearch
endfunction
command! -complete=command LargeFile call LargeFile()

function! LargeFileOff()
  filetype on
  filetype detect
  set incsearch
endfunction
command! -complete=command LargeFileOff call LargeFileOff()

function! SynStack()
  let s:syn_stack = ''
  for id in synstack(line("."), col("."))
    let s:syn_stack = s:syn_stack . ' > ' . synIDattr(id, "name")
  endfor
  echo s:syn_stack
  return s:syn_stack
endfunction

function! ShowSynStack()
  let g:old_statusline = &statusline
  let g:old_laststatus = &laststatus
  set statusline+=%{SynStack()}
  set laststatus=2
endfunction
command! -complete=command ShowSynStack call ShowSynStack()

function! HideSynStack()
  let &statusline=g:old_statusline
  let &laststatus=g:old_laststatus
endfunction
command! -complete=command HideSynStack call HideSynStack()

" Send the range to specified shell command's standard input
function! SendToCommand(UserCommand) range
  let SelectedLines = getline(a:firstline,a:lastline)
  " Convert to a single string suitable for passing to the command
  let ScriptInput = join(SelectedLines, "\n") . "\n"
  " Run the command
  echo system(a:UserCommand, ScriptInput)
endfunction
command! -complete=command -range -nargs=1 SendToCommand <line1>,<line2>call SendToCommand(<q-args>)

" Run the range as a shell command
fu! RunCommand() range
  let RunCommandCursorPos = getpos(".")
  let SelectedLines = getline(a:firstline,a:lastline)
  " Convert to a single string suitable for passing to the command
  let ScriptInput = join(SelectedLines, " ") . "\n"
  echo system(ScriptInput)
  call setpos(".", RunCommandCursorPos)
endfu
command! -complete=command -range RunCommand <line1>,<line2>call RunCommand()
map <unique> <leader>! :RunCommand<CR>

function! StripTrailingWhitespace(line1, line2)
  let _s=@/ | exe "normal! msHmt" | exe 'keepj '.a:line1.",".a:line2.'s/\s\+$//e' | let @/=_s | nohl | exe "normal! 'tzt`s"
endfunction
command! -range=% -complete=command StripTrailingWhitespace call StripTrailingWhitespace(<line1>, <line2>)

function! ToggleDiffIgnoreWhitespace()
  if match(&diffopt, 'iwhite') == -1
    set diffopt+=iwhite
  else
    set diffopt-=iwhite
  endif
  set diffopt?
endfunction
command! -complete=command ToggleDiffIgnoreWhitespace call ToggleDiffIgnoreWhitespace()
noremap <silent> <unique> <leader>W :ToggleDiffIgnoreWhitespace<CR>

function! DefaultFont()
  set guifont=Menlo:h11
endfunction
command! -complete=command DefaultFont call DefaultFont()

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
