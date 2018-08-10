if exists("b:lazarus_java")
  finish
endif
let b:lazarus_java = 1

let s:mvn_output_converter = expand('<sfile>:p:h') . '/mvn_test_conversion.rb'
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
  update | call neomake#Make(0, enabled_makers) | echo "running: " . cmd
endfunction
command! -complete=command -nargs=? RunMvnTest call RunMvnTest(<q-args>)

function! RunPantsTest()
  let s:test_file = matchlist(expand('%'), '^\(.\+\)/src/test/java/\(.\+\)\.java$')

  if empty(s:test_file)
    echo "couldn't find a test file"
    return
  endif

  let cmd = './pants test ' . s:test_file[1] . ':test --test-junit-test=' . substitute(s:test_file[2], '/', '.', 'g')
  let @+ = cmd

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echo "running: " . cmd
endfunction
command! -complete=command -nargs=? RunPantsTest call RunPantsTest()

if exists('g:java_pants') && g:java_pants
  noremap <buffer> <silent> <unique> <leader>r :RunPantsTest<CR>
  "compiler pants
else
  noremap <buffer> <silent> <unique> <leader>r :RunMvnTest<CR>
  noremap <buffer> <silent> <unique> <leader>R :RunMvnTest 1<CR>
  compiler mvn
endif
