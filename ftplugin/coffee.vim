if exists("b:lazarus_coffee")
  finish
endif
let b:lazarus_coffee = 1

function! RunKarmaTest()
  if exists('g:karma')
    let karma = g:karma
  else
    let karma = ' KARMA_BROWSERS=Chrome ./script/development'
  endif

  if match(expand('%'), '\.test\.coffee$') > -1
    let s:test_file = expand('%')
  elseif !exists('s:test_file')
    let s:test_file = expand('%')
  endif

  let cmd = ':Dispatch RUN_LIST=' . s:test_file . karma

  update | exe cmd
endfunction
command! -complete=command RunKarmaTest call RunKarmaTest()
noremap <buffer> <silent> <unique> <leader>r :RunKarmaTest<CR>
