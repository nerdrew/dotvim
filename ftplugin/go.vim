if exists("b:lazarus_go")
  finish
endif
let b:lazarus_go = 1

function! s:RunGoTest(mode) abort
  if match(expand('%'), '_test\.go$') > -1
    let s:test_package = './'.expand('%:h')
    let s:test_function = substitute(tagbar#currenttag('%s', ''), '()$', '', '')
    if s:test_function == ''
      throw 'could not find the current function'
    endif
  endif

  if !exists('s:test_package')
    let s:test_package = './'.expand('%:h')
  endif

  let cmd = 'go test '.s:test_package

  if a:mode
    if exists('s:test_function') && match(s:test_function, '^Test') > -1
      let cmd .= " --run '^" . s:test_function . "$'"
    else
      throw 'invalid go test function='.s:test_function
    endif
  endif

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  " --- FAIL: TestFunction (2.17s)
  " 	file_test.go:366: failure message
  let custom_maker.errorformat = '%E--- FAIL: %m,%Z%f:%l: %m,%E%># %.%#,%Z%f:%l:%c: %m'
  let custom_maker.mapexpr = 'substitute(v:val, "\\v^(\\s+)(\\S+:\\d+:\\s+.*)$", "\\1".neomake_bufdir."/\\2", "")'
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echo "running: " . cmd
endfunction
command! -complete=command -bang RunGoTest call s:RunGoTest(<bang>0)

function! s:DebugGoTest(mode) abort
  if match(expand('%'), '_test\.go$') > -1
    let s:test_package = './'.expand('%:h')
    let s:test_function = substitute(tagbar#currenttag('%s', ''), '()$', '', '')
    if s:test_function == ''
      throw 'could not find the current function'
    endif
  endif

  if !exists('s:test_package')
    let s:test_package = './'.expand('%:h')
  endif

  if a:mode
    if exists('s:test_function') && match(s:test_function, '^Test') > -1
      let flags = "-- -test.run '^" . s:test_function . "$'"
    else
      throw 'invalid go test function='.s:test_function
    endif
  else
    let flags = ""
  endif

  update | call delve#runCommand('test', flags, s:test_package) | echo "running: delve#runCommand('test', ".flags.", ".s:test_package.")"
endfunction
command! -complete=command -bang DebugGoTest call s:DebugGoTest(<bang>0)

noremap <buffer> <silent> <unique> <leader>e :DebugGoTest<CR>
noremap <buffer> <silent> <unique> <leader>E :DebugGoTest!<CR>
noremap <buffer> <silent> <unique> <leader>r :RunGoTest<CR>
noremap <buffer> <silent> <unique> <leader>R :RunGoTest!<CR>
noremap <buffer> <silent> <unique> <leader>s :DlvToggleBreakpoint<CR>
noremap <buffer> <silent> <unique> <leader>S :DlvClearAll<CR>
