if exists("b:lazarus_rust")
  finish
endif
let b:lazarus_rust = 1

function! CargoTest(filter)
  let &l:makeprg = 'cargo test ' . a:filter
  " ignore lines: ignore blank / whitespace lines
  let &l:efm = '%f:%l:%m, %f:%l %m, %m\, %f:%l, %-G\\s%#'
  update | Neomake! | echo "running: cargo test " . a:filter
endfunction
command! -complete=command -nargs=? CargoTest call CargoTest(<q-args>)
noremap <buffer> <silent> <unique> <leader>r :CargoTest<CR>
noremap <buffer> <silent> <unique> <leader>R :exe CargoTest(expand('<cword>'))<CR>
