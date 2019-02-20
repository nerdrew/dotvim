" if exists("b:lazarus_java")
"   finish
" endif
" let b:lazarus_java = 1

noremap <leader>] :call CscopeForTermUnderCursor()<cr>

if exists('g:java_pants') && g:java_pants
  noremap <buffer> <silent> <unique> <leader>s :RunPantsTest<CR>
  noremap <buffer> <silent> <unique> <leader>r :RunPantsTest 1<CR>
  noremap <buffer> <silent> <unique> <leader>R :RunPantsTest 2<CR>
  "compiler pants
else
  noremap <buffer> <silent> <unique> <leader>r :RunMvnTest<CR>
  noremap <buffer> <silent> <unique> <leader>R :RunMvnTest!<CR>
  compiler mvn
endif

if exists('g:lazarus_java')
  finish
endif
let g:lazarus_java = 1

let s:mvn_output_converter = expand('<sfile>:p:h') . '/mvn_test_conversion.rb'
let s:pants_output_converter = expand('<sfile>:p:h') . '/pants_conversion.rb'
function! RunMvnTest(single)
  if exists('g:mvn_test')
    let cmd = g:mvn_test
  else
    let cmd = 'mvn test'
  endif

  if match(expand('%'), '^src/test.\+\.java$') > -1
    let s:test_file = '%:t'
  endif

  if a:single
    let cmd.= ' -Dtest='. s:test_file
  endif
  let cmd .= ' | ' . s:mvn_output_converter

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . cmd
endfunction
command! -complete=command -bang RunMvnTest call RunMvnTest(<bang>0)

function! s:GetCurrentTest() abort
  let l:test_file = matchlist(expand('%'), '^\(.\+\)/src/test/java/\(.\+\)\.java$')

  if !empty(test_file)
    let s:test_file = l:test_file
    let s:test_function = substitute(tagbar#currenttag('%s', '', ''), '()$', '', '')
  endif

  if !exists('s:test_file')
    let main_file = matchlist(expand('%'), '^\(.\+\)/src/main/java/\(.\+\)\.java$')
    let test_file = l:main_file[1].'/src/test/java/'.l:main_file[2].'Test.java'
    if filereadable(l:test_file)
      let s:test_file = matchlist(l:test_file, '^\(.\+\)/src/test/java/\(.\+\)\.java$')
      let s:test_function = ''
    else
      throw 'could not find the test'
    endif
  endif

  return { 'file': s:test_file[1], 'package': substitute(s:test_file[2], '/', '.', 'g'), 'function': s:test_function }
endfunction

function! RunPantsTest(mode)
  let l:test = s:GetCurrentTest()
  let l:current_dir = fnamemodify(getcwd(), ':s?'. g:ale_java_pants_root .'/??') . '/' . l:test.file

  let cmd = 'cd '.g:ale_java_pants_root.' && ./pants --no-colors test '.l:current_dir.':test'

  if a:mode
    let cmd .= ' --test-junit-test='.l:test.package

    if a:mode == 2 && !empty(l:test.function)
      let cmd .= '#'.l:test.function
    endif
  endif

  "let cmd = 'cat boom-compile-error.txt boom-test-failure.txt'
  let cmd .= ' | ruby ' . s:pants_output_converter . ' -- ' . l:current_dir

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.cwd = g:ale_java_pants_root
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . cmd
endfunction
command! -complete=command -nargs=? RunPantsTest call RunPantsTest(<q-args>)

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

if filereadable(".git/cscope.out")
  execute "cs add .git/cscope.out"
endif


" jdb
"-------------------------------------------------------------------------------
"                           Configuration options
"-------------------------------------------------------------------------------

if !exists("g:java_jdb_cache_path")
  let g:java_jdb_cache_path = $HOME ."/.cache/". v:progname ."/vim-java_jdb"
endif

" g:java_jdb_breakpoint_sign sets the sign to use in the gutter to indicate
" breakpoints.
if !exists("g:java_jdb_breakpoint_sign")
  let g:java_jdb_breakpoint_sign = "●"
endif

" g:java_jdb_breakpoint_sign_highlight sets the highlight color for the breakpoint
" sign.
if !exists("g:java_jdb_breakpoint_sign_highlight")
  let g:java_jdb_breakpoint_sign_highlight = "WarningMsg"
endif

" g:java_jdb_watchpoint_sign sets the sign to use in the gutter to indicate
" watchpoints.
if !exists("g:java_jdb_watchpoint_sign")
  let g:java_jdb_watchpoint_sign = "◆"
endif

" g:java_jdb_watchpoint_sign_highlight sets the highlight color for the watchpoint
" sign.
if !exists("g:java_jdb_watchpoint_sign_highlight")
  let g:java_jdb_watchpoint_sign_highlight = "WarningMsg"
endif

" g:java_jdb_instructions_file holdes the path to the instructions file. It should
" be reasonably unique.
let g:java_jdb_instructions_file = g:java_jdb_cache_path ."/". getpid() .".". localtime()

"-------------------------------------------------------------------------------
"                              Implementation
"-------------------------------------------------------------------------------
" java_jdb_instructions holds all the instructions to java_jdb in a list.
let s:java_jdb_instructions = []

" Ensure that the cache path exists.
call mkdir(g:java_jdb_cache_path, "p")

" Remove the instructions file
autocmd VimLeave * call s:JavaRemoveInstructionsFile()

" Configure the breakpoint and watchpoint signs in the gutter.
exe "sign define java_jdb_breakpoint text=". g:java_jdb_breakpoint_sign ." texthl=". g:java_jdb_breakpoint_sign_highlight
exe "sign define java_jdb_watchpoint text=". g:java_jdb_watchpoint_sign ." texthl=". g:java_jdb_watchpoint_sign_highlight

function! s:JavaClearAll()
  for i in range(len(s:java_jdb_instructions))
    exe "sign unplace ". eval(i+1)
  endfor

  let s:java_jdb_instructions = []
  call s:JavaRemoveInstructionsFile()
endfunction
command! -nargs=0 JavaClearAll call s:JavaClearAll()

function! s:JavaRemoveInstructionsFile()
  call delete(g:java_jdb_instructions_file)
endfunction

function! s:DebugJavaTest(mode)
  if a:mode
    let test_function = s:GetCurrentTest()
  endif

  call s:JavaWriteInstructionsFile()

  " brew python makes lldb sad
  let cmd = 'set -x; '
        \. 'RUST_TEST_THREADS=1 TEST_BINARY=$(cd '. g:ale_java_pants_root .'; cargo test '.l:test_function.' 2>&1 | tee /dev/stderr | ggrep -oP "(?<=Running ).*$" | head -1); '
        \. 'PATH=/usr/bin:$PATH rust-lldb -s '.g:java_jdb_instructions_file.' -- $TEST_BINARY '.l:test_function

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
  startinsert
endfunction
command! -bang DebugJavaTest call s:DebugJavaTest(<bang>0)

function! s:JavaAddBreakpoint(file, line)
  let breakpoint = "stop at ". a:file .":". a:line

  call add(s:java_jdb_instructions, breakpoint)

  exe "sign place ". len(s:java_jdb_instructions) ." line=". a:line ." name=java_jdb_breakpoint file=". a:file
endfunction

function! s:JavaRemoveBreakpoint(file, line)
  let breakpoint = "clear ". a:file .":". a:line

  let i = index(s:java_jdb_instructions, breakpoint)
  if i != -1
    call remove(s:java_jdb_instructions, i)
    exe "sign unplace ". eval(i+1) ." file=". a:file
  endif
endfunction

" toggleBreakpoint is toggling breakpoints at the line under the cursor.
function! s:JavaToggleBreakpoint(file, line)
  let breakpoint = "stop at ". a:file .":". a:line

  " Find the breakpoint in the instructions, if available. If it's already
  " there, remove it. If not, add it.
  if index(s:java_jdb_instructions, breakpoint) == -1
    call s:JavaAddBreakpoint(a:file, a:line)
  else
    call s:JavaRemoveBreakpoint(a:file, a:line)
  endif
endfunction
command! -nargs=0 JavaToggleBreakpoint call s:JavaToggleBreakpoint(expand('%:p'), line('.'))

" writeInstructionsFile is persisting the instructions to the set file.
function! s:JavaWriteInstructionsFile()
  call s:JavaRemoveInstructionsFile()
  call writefile(s:java_jdb_instructions + [
        \ 'run',
        \ ], g:java_jdb_instructions_file)
endfunction
