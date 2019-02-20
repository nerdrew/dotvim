if exists("b:lazarus_go")
  finish
endif
let b:lazarus_go = 1

"let b:ale_completion_manual = 1

noremap <buffer> <silent> <unique> <leader>e :DebugGoTest<CR>
noremap <buffer> <silent> <unique> <leader>E :DebugGoTest!<CR>
noremap <buffer> <silent> <unique> <leader>r :RunGoTest<CR>
noremap <buffer> <silent> <unique> <leader>R :RunGoTest!<CR>
noremap <buffer> <silent> <unique> <leader>s :DlvToggleBreakpoint<CR>
noremap <buffer> <silent> <unique> <leader>S :DlvClearAll<CR>

if exists("g:lazarus_go")
  finish
endif
let g:lazarus_go = 1

function! s:GetCurrentPackage() abort
  if match(expand('%'), '_test\.go$') > -1
    let l:test_package = './'.expand('%:h')
    if l:test_package == ''
      throw 'could not find the current package'
    else
      let s:test_package = l:test_package
    endif
  endif
  return s:test_package
endfunction

function! s:GetCurrentFunction() abort
  let test_function = substitute(tagbar#currenttag('%s', ''), '()$', '', '')
  if match(l:test_function, '^Test') > -1
    let s:test_function = l:test_function
  endif

  if !exists('s:test_function') || s:test_function == ''
    throw 'invalid go test function='.s:test_function
  endif

  return s:test_function
endfunction

function! s:RunGoTest(mode) abort
  let cmd = 'go test '.s:GetCurrentPackage()

  if a:mode
    let cmd .= " --run '^" . s:GetCurrentFunction() . "$'"
  endif

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  " --- FAIL: TestFunction (2.17s)
  " 	file_test.go:366: failure message
  let custom_maker.errorformat = '%E--- FAIL: %m, %Z%f:%l: %m, %E%># %.%#, %Z%f:%l:%c: %m'
  let custom_maker.mapexpr = 'substitute(v:val, "\\v^(\\s+)(\\S+:\\d+:\\s+.*)$", "\\1".neomake_bufdir."/\\2", "")'
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . cmd
endfunction
command! -complete=command -bang RunGoTest call s:RunGoTest(<bang>0)

function! s:DebugGoTest(mode) abort
  if a:mode
    let flags = "-- -test.run '^" . s:GetCurrentFunction() . "$'"
  else
    let flags = ""
  endif

  update | call delve#runCommand('test', flags, s:GetCurrentPackage()) | echom "running: delve#runCommand('test', ".flags.", ".s:GetCurrentPackage().")"
endfunction
command! -complete=command -bang DebugGoTest call s:DebugGoTest(<bang>0)
