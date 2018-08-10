if exists("b:lazarus_rust")
  finish
endif
let b:lazarus_rust = 1

function! CargoTest(filter)
  let &l:makeprg = 'cargo test ' . a:filter
  " ignore lines: ignore blank / whitespace lines
  let &l:efm = '%f:%l:%m, %f:%l %m, %m\, %f:%l, %-G\\s%#'
  update | Neomake! | echo "running: cargo test " . a:filter

  "let cmd = 'cargo test'

  "if a:filter
    "let s:test_function = substitute(tagbar#currenttag('%s', ''), '()$', '', '')
    "if s:test_function == ''
      "throw 'could not find the current function'
    "endif
  "endif

  "let custom_maker = neomake#utils#MakerFromCommand(cmd)
  "let custom_maker.name = cmd
  "let custom_maker.remove_invalid_entries = 0
  "let custom_maker.errorformat = '%f:%l:%m, %f:%l %m, %m\, %f:%l, %-G\\s%#'
  "let custom_maker.mapexpr = 'substitute(v:val, "\\v^(\\s+)(\\S+:\\d+:\\s+.*)$", "\\1".neomake_bufdir."/\\2", "")'
  "let enabled_makers =  [custom_maker]
  "update | call neomake#Make(0, enabled_makers) | echo "running: " . cmd
endfunction
command! -complete=command -nargs=? CargoTest call CargoTest(<q-args>)

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


if has('autocmd')
  if executable('rls')
    autocmd User lsp_setup call lsp#register_server({ 'name': 'rls', 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']}, 'whitelist': ['rust'], })
  endif
endif

noremap <buffer> <silent> <unique> <leader>r :CargoTest<CR>
noremap <buffer> <silent> <unique> <leader>R :exe CargoTest(expand('<cword>'))<CR>
noremap <buffer> <silent> <leader>] :call RacerForTermUnderCursor()<cr>
