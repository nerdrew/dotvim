if exists("b:lazarus_ruby")
  finish
endif
let b:lazarus_ruby = 1

function! s:RunRubyTest(mode)
  if exists('g:rspec')
    let rspec = g:rspec
  elseif glob('.zeus.sock') == '.zeus.sock'
    let rspec = 'zeus rspec'
  elseif glob('bin/rspec') == 'bin/rspec'
    let rspec = 'bin/rspec'
  else
    let rspec = 'bundle exec rspec'
  endif

  if match(expand('%'), '_spec\.rb$') > -1
    let s:spec_file = expand('%')
    let s:spec_line = line('.')
  endif

  if !exists('s:spec_file')
    let s:spec_file = '%'
  endif

  let cmd = rspec . ' -f p '

  if a:mode
    let cmd .= s:spec_file

    if a:mode == 2
      let cmd.= ':'. s:spec_line
    endif
  endif

  " Match file:line message, ignore lines: ^\.|F$, ignore blank / whitespace
  " lines
  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.errorformat = 'rspec %f:%l %m'
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echo "running: " . cmd
endfunction
command! -complete=command -nargs=? RunRubyTest call s:RunRubyTest(<q-args>)
noremap <buffer> <silent> <unique> <leader>s :RunRubyTest<CR>
noremap <buffer> <silent> <unique> <leader>r :RunRubyTest 1<CR>
noremap <buffer> <silent> <unique> <leader>R :RunRubyTest 2<CR>
