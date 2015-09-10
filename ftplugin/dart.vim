if exists("b:lazarus_dart")
  finish
endif
let b:lazarus_dart = 1

function! Dartfmt()
  exe "normal! msHmt" | exe 'keepj %!dartfmt -l 100 -t' | exe 'keepj normal! GGdd' | exe "normal! 'tzt`s"
endfunction
command! -complete=command Dartfmt call Dartfmt()

if has('autocmd')
  "autocmd FileType dart autocmd BufWritePre <buffer> Dartfmt
endif
