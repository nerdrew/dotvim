if exists('b:lazarus_rust')
  finish
endif
let b:lazarus_rust = 1

let b:rust_project_root = get(b:, 'rust_project_root', FindRootDirectory())

noremap <buffer> <silent> <unique> <leader>e :DebugRustTest<CR>
noremap <buffer> <silent> <unique> <leader>E :DebugRustTest!<CR>
noremap <buffer> <silent> <unique> <leader>r :RunRustTest<CR>
noremap <buffer> <silent> <unique> <leader>R :RunRustTest!<CR>
noremap <buffer> <silent> <unique> <leader>s :RustToggleBreakpoint<CR>
noremap <buffer> <silent> <unique> <leader>S :RustClearAll<CR>

"noremap <buffer> <silent> <leader>] :call RacerForTermUnderCursor()<cr>
"noremap <buffer> <silent> <unique> K :call LanguageClient#textDocument_hover()<CR>
"noremap <buffer> <silent> <unique> <leader>] :call LanguageClient#textDocument_definition()<CR>
"imap <buffer> <tab> <c-o>:call ale#completion#ManualQueue()<cr>
"imap <buffer> <silent> <expr> <tab> pumvisible() ? "\<tab>" : "\<c-o>:call ale#completion#ManualQueue()\<cr>"

"set completeopt=menu,preview,noinsert
"set completefunc=LanguageClient#complete

if exists('g:lazarus_rust')
  finish
endif
let g:lazarus_rust = 1

let g:rust_workspace_root = get(g:, 'rust_workspace_root', json_decode(system('cargo metadata --format-version 1'))['workspace_root'])

function! s:GetCurrentTest() abort
  let test_function = substitute(tagbar#currenttag('%s', '', 'f'), '()$', '', '')
  if match(test_function, '^tests::') > -1
    let s:test_function = l:test_function
  endif
  if !exists('s:test_function') || s:test_function == ''
    throw 'could not find the current function'
  endif
  return s:test_function
endfunction

function! s:RunRustTest(mode) abort
  let cmd = 'cargo test '

  if !ale#Var(bufnr('%'), 'rust_cargo_check_tests')
    let cmd .= '--lib '
  endif

  if a:mode
    let cmd .= s:GetCurrentTest()
  endif

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.cwd = b:rust_project_root
  " thread 'search::tests::search_no_context' panicked at 'assertion failed: `(left == right)`
  "   left: `SearchResult { matches: Matches({None: {(2, 2), (5, 5)}}), has_groups: Some(false) }`,
  "   right: `SearchResult { matches: Matches({None: {(2, 2), (4, 5)}}), has_groups: Some(false) }`', src/search.rs:322:9
  let custom_maker.errorformat = '%Ethread %m, %Z%m\,%f:%l:%c, %C%m'
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . cmd
endfunction
command! -complete=command -bang RunRustTest call s:RunRustTest(<bang>0)

function! RacerForTermUnderCursor()
  call inputsave()
  let type = ''
  let validTypes = ['g', 's', 'v', 'd']
  let quitTypes = ['q', '', '']
  echo 'racer navigation (g=rust-def/s=rust-def-split/v=rust-def-vertical/d=rust-doc/q=quit): '
  while index(validTypes, type) == -1
    let type = nr2char(getchar())
    if index(quitTypes, type) >= 0
      redraw!
      return
    endif
  endwhile
  call inputrestore()

  if type == 'g'
    call racer#GoToDefinition()
  elseif type == 's'
    split
    call racer#GoToDefinition()
  elseif type == 'v'
    vsplit
    call racer#GoToDefinition()
  elseif type == 'd'
    call racer#ShowDocumentation()
  endif
endfunction


" rust-lldb
"-------------------------------------------------------------------------------
"                           Configuration options
"-------------------------------------------------------------------------------

if !exists("g:rust_lldb_cache_path")
  let g:rust_lldb_cache_path = $HOME ."/.cache/". v:progname ."/vim-rust_lldb"
endif

" g:rust_lldb_breakpoint_sign sets the sign to use in the gutter to indicate
" breakpoints.
if !exists("g:rust_lldb_breakpoint_sign")
  let g:rust_lldb_breakpoint_sign = "●"
endif

" g:rust_lldb_breakpoint_sign_highlight sets the highlight color for the breakpoint
" sign.
if !exists("g:rust_lldb_breakpoint_sign_highlight")
  let g:rust_lldb_breakpoint_sign_highlight = "WarningMsg"
endif

" g:rust_lldb_watchpoint_sign sets the sign to use in the gutter to indicate
" watchpoints.
if !exists("g:rust_lldb_watchpoint_sign")
  let g:rust_lldb_watchpoint_sign = "◆"
endif

" g:rust_lldb_watchpoint_sign_highlight sets the highlight color for the watchpoint
" sign.
if !exists("g:rust_lldb_watchpoint_sign_highlight")
  let g:rust_lldb_watchpoint_sign_highlight = "WarningMsg"
endif

" g:rust_lldb_instructions_file holdes the path to the instructions file. It should
" be reasonably unique.
let g:rust_lldb_instructions_file = g:rust_lldb_cache_path ."/". getpid() .".". localtime()

"-------------------------------------------------------------------------------
"                              Implementation
"-------------------------------------------------------------------------------
" rust_lldb_instructions holds all the instructions to rust_lldb in a list.
let s:rust_lldb_instructions = []

" Ensure that the cache path exists.
call mkdir(g:rust_lldb_cache_path, "p")

" Remove the instructions file
autocmd VimLeave * call s:RustRemoveInstructionsFile()

" Configure the breakpoint and watchpoint signs in the gutter.
exe "sign define rust_lldb_breakpoint text=". g:rust_lldb_breakpoint_sign ." texthl=". g:rust_lldb_breakpoint_sign_highlight
exe "sign define rust_lldb_watchpoint text=". g:rust_lldb_watchpoint_sign ." texthl=". g:rust_lldb_watchpoint_sign_highlight

function! s:RustClearAll()
  for i in range(len(s:rust_lldb_instructions))
    exe "sign unplace ". eval(i+1)
  endfor

  let s:rust_lldb_instructions = []
  call s:RustRemoveInstructionsFile()
endfunction
command! -nargs=0 RustClearAll call s:RustClearAll()

function! s:RustRemoveInstructionsFile()
  call delete(g:rust_lldb_instructions_file)
endfunction

function! s:DebugRustTest(mode)
  if a:mode
    let test_function = s:GetCurrentTest()
  else
    let test_function = ''
  endif

  call s:RustWriteInstructionsFile()

  " brew python makes lldb sad
  let cmd = 'set -x; '
        \. 'RUST_TEST_THREADS=1 TEST_BINARY=$(cd '. b:rust_project_root .'; cargo test '.l:test_function.' 2>&1 | tee /dev/stderr | grep -oP "(?<=Running ).*$" | head -1); '
        \. 'rust-lldb -s '.g:rust_lldb_instructions_file.' -- $TEST_BINARY '.l:test_function

  update

  if winnr('$') == 1
    vnew
  else
    cclose
    lclose
    botright new
  endif

  echom "running: " . cmd
  call termopen(cmd)
endfunction
command! -bang DebugRustTest call s:DebugRustTest(<bang>0)

function! s:RustAddBreakpoint(file, line)
  let breakpoint = "breakpoint set -f ". a:file ." -l ". a:line

  call add(s:rust_lldb_instructions, breakpoint)

  exe "sign place ". len(s:rust_lldb_instructions) ." line=". a:line ." name=rust_lldb_breakpoint file=". a:file
endfunction

function! s:RustRemoveBreakpoint(file, line)
  let breakpoint = "breakpoint set -f ". a:file ." -l ". a:line

  let i = index(s:rust_lldb_instructions, breakpoint)
  if i != -1
    call remove(s:rust_lldb_instructions, i)
    exe "sign unplace ". eval(i+1) ." file=". a:file
  endif
endfunction

" toggleBreakpoint is toggling breakpoints at the line under the cursor.
function! s:RustToggleBreakpoint(file, line)
  let breakpoint = "breakpoint set -f ". a:file ." -l ". a:line

  " Find the breakpoint in the instructions, if available. If it's already
  " there, remove it. If not, add it.
  if index(s:rust_lldb_instructions, breakpoint) == -1
    call s:RustAddBreakpoint(a:file, a:line)
  else
    call s:RustRemoveBreakpoint(a:file, a:line)
  endif
endfunction
command! -nargs=0 RustToggleBreakpoint call s:RustToggleBreakpoint(expand('%:p'), line('.'))

" writeInstructionsFile is persisting the instructions to the set file.
function! s:RustWriteInstructionsFile()
  call s:RustRemoveInstructionsFile()
  call writefile(s:rust_lldb_instructions + [
        \ 'b rust_panic',
        \ "command regex ls 's/^$/frame variable/' 's/(\w+)/image lookup -rn %1::\w+::\w+$/'",
        \ 'run',
        \ ], g:rust_lldb_instructions_file)
endfunction

function! s:CargoCheck()
  let check_cmd = 'cargo check --quiet --workspace --tests --all-targets --bins --examples --message-format json'

  let cmd = check_cmd . ' 2>&1 | '
        \. "jq -r 'select(.reason != \"compiler-artifact\") | .message | try \"\\(.spans[] | \"\\(.file_name):\\(.line_start):\\(.column_start)\"): \\(.level[0:1]) \\(.message)\"' | "
        \. 'sort -t : -k1,1 -k 2,2n -k 3,3n -u'
  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.cwd = g:rust_workspace_root
  let custom_maker.remove_invalid_entries = 1
  " let custom_maker.errorformat = '%f:%l:%c: %t%*[^:]: %m'
  let custom_maker.errorformat = '%f:%l:%c: %t %m'
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . check_cmd
endfunction
command! CargoCheck call s:CargoCheck()
