if exists("b:lazarus_java")
  finish
endif
let b:lazarus_java = 1

noremap <leader>] :call CscopeForTermUnderCursor()<cr>

noremap <buffer> <silent> <unique> <leader>e :RunJavaTest! 1<CR>
noremap <buffer> <silent> <unique> <leader>E :RunJavaTest! 2<CR>
noremap <buffer> <silent> <unique> <leader>r :RunJavaTest 1<CR>
noremap <buffer> <silent> <unique> <leader>R :RunJavaTest 2<CR>
noremap <buffer> <silent> <unique> <leader>s :JavaToggleBreakpoint<CR>
noremap <buffer> <silent> <unique> <leader>S :JavaClearAll<CR>
noremap <buffer> <silent> <unique> <leader>D :GetCurrentTest<CR>

if exists('g:lazarus_java')
  finish
endif
let g:lazarus_java = 1

let s:google_java_formatter = expand('<sfile>:p:h').'/google-java-format-1.7-all-deps.jar'

function! s:JavaFormat(line1, line2)
  let l:file = expand('%')

  let l:cmd = 'java -jar '.s:google_java_formatter.' --assume-filename='.l:file.' --lines='.a:line1.':'.a:line2.' -'
  execute a:line1.','.a:line2.' !'.l:cmd
endfunction
command! -range=% -complete=command JavaFormat call s:JavaFormat(<line1>, <line2>)

function! RunJavaTest(mode, debug)
  if exists('g:java_pants') && g:java_pants
    call s:RunPantsTest(a:mode, a:debug)
  else
    call s:RunMvnTest(a:mode)
  endif
endfunction
command! -complete=command -nargs=? -bang RunJavaTest call RunJavaTest(<f-args>, <bang>0)

let s:mvn_output_converter = expand('<sfile>:p:h') . '/mvn_test_conversion.rb'
let s:current_test = {'test': 0}
function! s:RunMvnTest(mode)
  if exists('g:mvn_test')
    let cmd = g:mvn_test
  else
    let cmd = 'mvn test'
  endif

  if match(expand('%'), '^src/test.\+\.java$') > -1
    let s:test_file = '%:t'
  endif

  if a:mode
    let cmd.= ' -Dtest='. s:test_file
  endif
  let cmd .= ' | ' . s:mvn_output_converter

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . cmd
endfunction

function! s:GetCurrent(...) abort
  if a:0 > 0
    let l:path = a:1
  else
    let l:path = expand('%')
  endif
  let l:file = matchlist(l:path, '^\(.\+\)/src/\(test\|main\)/java/\(.\+\)\.java$')

  if empty(l:file)
    return s:current_file
  endif

  let s:current_file = {
        \ 'root': fnamemodify(getcwd(), ':s?'. g:ale_java_pants_root .'/??') . '/' . l:file[1],
        \ 'test': l:file[2] == 'test',
        \ 'file': l:path,
        \ 'package': substitute(l:file[3], '/', '.', 'g'),
        \ }

  return s:current_file
endfunction

function! s:GetCurrentTest() abort
  let l:file = s:GetCurrent()

  if !l:file.test
    if s:current_test.test
      return s:current_test
    endif

    let l:test_file = l:file.root.'/src/test/java/'.substitute(l:file.package, '.', '/', 'g').'Test.java'
    if filereadable(l:test_file)
      let l:file = s:GetCurrent(l:test_file)
      let l:test_function = ''
    else
      throw 'could not find the test'
    endif
  else
    let l:test_function = substitute(tagbar#currenttag('%s', '', ''), '()$', '', '')
  endif

  let s:current_test = l:file
  let s:current_test['function'] = l:test_function

  return s:current_test
endfunction
command! -complete=command -nargs=0 GetCurrentTest echo s:GetCurrentTest()

let s:pants_output_converter = expand('<sfile>:p:h') . '/pants_conversion.rb'

function! DebugPostprocess(_type, text) abort
  if match(a:text, 'Listening for transport dt_socket at address: 5005') >= 0
    "echom 'debug socket listening match='.a:text
    call s:DebugJavaTest()
  endif

  return a:text
endfunction

function! s:RunPantsTest(mode, debug)
  let l:test = s:GetCurrentTest()

  let l:pants_cmd = './pants --no-colors test '.l:test.root.':test'

  if a:mode
    let l:pants_cmd .= ' --test-junit-test='.l:test.package

    if a:mode == 2 && !empty(l:test.function)
      let l:pants_cmd .= '#'.l:test.function
    endif
  endif

  if a:debug
     let l:pants_cmd .= ' --jvm-test-junit-debug'
  endif

  let l:cmd = 'cd '.g:ale_java_pants_root.' && '.l:pants_cmd

  "let cmd = 'cat boom-compile-error.txt boom-test-failure.txt'
  let l:cmd .= ' 2>&1 | ruby ' . s:pants_output_converter . ' -- ' . l:test.root

  let custom_maker = neomake#utils#MakerFromCommand(l:cmd)
  let custom_maker.name = l:cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.cwd = g:ale_java_pants_root
  if a:debug
    let s:debugged = 0
    let custom_maker.buffer_output = 0
    let custom_maker.mapexpr = function('DebugPostprocess')
  endif
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . l:pants_cmd
  if a:debug
    cope
  endif
endfunction

function! s:RunBazelTest()
  let l:test = s:GetCurrentTest()

  let l:bazel_cmd = 'bazel test '.l:test.root.''

  let l:cmd = 'cd '.g:ale_java_pants_root.' && '.l:pants_cmd

  "let cmd = 'cat boom-compile-error.txt boom-test-failure.txt'
  let l:cmd .= ' 2>&1 | ruby ' . s:pants_output_converter . ' -- ' . l:test.root

  let custom_maker = neomake#utils#MakerFromCommand(l:cmd)
  let custom_maker.name = l:cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.cwd = g:ale_java_pants_root
  if a:debug
    let s:debugged = 0
    let custom_maker.buffer_output = 0
    let custom_maker.mapexpr = function('DebugPostprocess')
  endif
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . l:pants_cmd
  if a:debug
    cope
  endif
endfunction

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
  call delete(g:java_jdb_instructions_file.'-breakpoints')
  call delete(g:java_jdb_instructions_file.'-sourcepaths')
endfunction

function! s:DebugJavaTest()
  if get(s:, 'debugged', 1)
    return
  endif

  let s:debugged = 1

  call s:JavaWriteInstructionsFile()

  " \ 'RLJDB_DEBUG=1 '
  let cmd = 'RLJDB_BREAKPOINT_FILE='.g:java_jdb_instructions_file.'-breakpoints '.
        \ 'RLJDB_SOURCEPATH_FILE='.g:java_jdb_instructions_file.'-sourcepaths '.
        \ 'rljdb -attach localhost:5005 -launch'

  update

  " The quickfix gets opened first
  if winnr('$') == 2
    topleft vnew
  else
    cclose
    lclose
    botright new
  endif

  echom "running: " . cmd
  call termopen(cmd)
endfunction

function! s:JavaAddBreakpoint(test, line)
  let breakpoint = a:test.package .":". a:line

  call add(s:java_jdb_instructions, breakpoint)

  let cmd = "sign place ". len(s:java_jdb_instructions) ." line=". a:line ." name=java_jdb_breakpoint file=". a:test.file
  echom cmd
  exe cmd
endfunction

function! s:JavaRemoveBreakpoint(test, line)
  let breakpoint = a:test.package .":". a:line

  let i = index(s:java_jdb_instructions, breakpoint)
  if i != -1
    call remove(s:java_jdb_instructions, i)
    exe "sign unplace ". eval(i+1) ." file=". a:test.file
  endif
endfunction

" toggleBreakpoint is toggling breakpoints at the line under the cursor.
function! s:JavaToggleBreakpoint(line)
  let current = s:GetCurrent()
  let breakpoint = current.package.":". a:line

  " Find the breakpoint in the instructions, if available. If it's already
  " there, remove it. If not, add it.
  if index(s:java_jdb_instructions, breakpoint) == -1
    call s:JavaAddBreakpoint(current, a:line)
  else
    call s:JavaRemoveBreakpoint(current, a:line)
  endif
endfunction
command! -nargs=0 JavaToggleBreakpoint call s:JavaToggleBreakpoint(line('.'))

" writeInstructionsFile is persisting the instructions to the set file.
function! s:JavaWriteInstructionsFile()
  call s:JavaRemoveInstructionsFile()
  call writefile(s:java_jdb_instructions, g:java_jdb_instructions_file.'-breakpoints')
  let root = s:GetCurrent().root
  echom root
  call writefile([root.'/src/main/java', root.'/src/test/java'], g:java_jdb_instructions_file.'-sourcepaths')
endfunction
