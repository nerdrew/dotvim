if exists("b:lazarus_java")
  finish
endif
let b:lazarus_java = 1

let s:output_converter = expand('<sfile>:p:h') . '/mvn_test_conversion.rb'
function! RunMvnTest(single)
  if exists('g:mvn_test')
    let mvn_test = g:mvn_test
  else
    let mvn_test = 'mvn test'
  endif

  if match(expand('%'), '^src/test.+\.java$') > -1
    let s:test_file = '%:t'
  endif

  if !exists('s:test_file')
    let s:test_file = '%:t'
  endif

  let cmd = ':Dispatch ' . mvn_test

  if a:single
    let cmd.= ' -Dtest='. s:test_file
  endif
  update | exe cmd . ' | ' . s:output_converter
endfunction
command! -complete=command -nargs=? RunMvnTest call RunMvnTest(<q-args>)
noremap <buffer> <silent> <unique> <leader>r :RunMvnTest<CR>
noremap <buffer> <silent> <unique> <leader>R :RunMvnTest 1<CR>
compiler mvn
