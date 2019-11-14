if exists("b:lazarus_ruby")
  finish
endif
let b:lazarus_ruby = 1

let b:ruby_project_root = get(b:, 'ruby_project_root', FindRootDirectory())

noremap <buffer> <silent> <unique> <leader>s :RunRubyTest<CR>
noremap <buffer> <silent> <unique> <leader>r :RunRubyTest 1<CR>
noremap <buffer> <silent> <unique> <leader>R :RunRubyTest 2<CR>
noremap <buffer> <silent> <unique> <leader>e :DebugRubyTest 1<CR>
noremap <buffer> <silent> <unique> <leader>E :DebugRubyTest 2<CR>
noremap <buffer> <silent> <unique> <leader>F :Format<CR>

if exists('g:lazarus_ruby')
  finish
endif
let g:lazarus_ruby = 1

if !exists('g:rspec')
  if glob('.zeus.sock') == '.zeus.sock'
    let g:rspec = 'zeus rspec'
  elseif glob('bin/rspec') == 'bin/rspec'
    let g:rspec = 'bin/rspec'
  else
    call system('grep -q spring Gemfile.lock')
    if !v:shell_error
      let g:rspec = 'spring rspec'
    else
      let g:rspec = 'bundle exec rspec'
    endif
  endif
endif

if !exists('g:rspec_args')
  let g:rspec_args = '-f p'
end

function! s:DebugRubyTest(mode)
  if match(expand('%'), '_spec\.rb$') > -1
    let s:spec_file = expand('%')
    let s:spec_line = line('.')
  endif

  if !exists('s:spec_file')
    let s:spec_file = expand('%')
  endif

  let cmd = ''
  if !empty(b:ruby_project_root)
    let cmd .= 'cd ' . b:ruby_project_root . ' && '
  endif
  let cmd .= get(b:, 'rspec', g:rspec) . ' ' . get(b:, 'rspec_args', g:rspec_args) . ' '

  if a:mode
    let cmd .= fnamemodify(s:spec_file, ':p:s?' . b:ruby_project_root . '/??')

    if a:mode == 2
      let cmd.= ':'. s:spec_line
    endif
  endif

  update

  if winnr('$') == 1
    vnew
  else
    cclose
    lclose
    botright new
  endif

  echom "running: " . cmd
  call termopen(cmd)

endfunction
command! -complete=command -nargs=? DebugRubyTest call s:DebugRubyTest(<q-args>)

function! s:RunRubyTest(mode)
  if match(expand('%'), '_spec\.rb$') > -1
    let s:spec_file = expand('%')
    let s:spec_line = line('.')
  endif

  if !exists('s:spec_file')
    let s:spec_file = expand('%')
  endif

  let cmd = ''
  if !empty(b:ruby_project_root)
    let cmd .= 'cd ' . b:ruby_project_root . ' && '
  endif
  let cmd .= 'DISABLE_PRY=1 '.get(b:, 'rspec', g:rspec) . ' ' . get(b:, 'rspec_args', g:rspec_args) . ' '

  if a:mode
    let cmd .= fnamemodify(s:spec_file, ':p:s?' . b:ruby_project_root . '/??')

    if a:mode == 2
      let cmd.= ':'. s:spec_line
    endif
  endif

  " Match file:line message, ignore lines: ^\.|F$, ignore blank / whitespace
  " lines
  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.cwd = b:ruby_project_root
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.errorformat = 'rspec %f:%l %m'
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . cmd
endfunction
command! -complete=command -nargs=? RunRubyTest call s:RunRubyTest(<q-args>)

function! s:Rubocop(path, autocorrect)
  let cmd = ''
  if !empty(b:ruby_project_root)
    let cmd .= 'cd ' . b:ruby_project_root . ' && '
  endif

  let cmd .= 'rubocop --format emacs '
  if a:autocorrect
    let cmd .= '--auto-correct '
  endif

  if !empty(a:path)
    let cmd .= fnamemodify(a:path, ':p:s?' . b:ruby_project_root . '/??')
  endif

  let custom_maker = neomake#utils#MakerFromCommand(cmd)
  let custom_maker.name = cmd
  let custom_maker.cwd = b:ruby_project_root
  let custom_maker.remove_invalid_entries = 0
  let custom_maker.errorformat = '%f:%l:%c: %m'
  let enabled_makers =  [custom_maker]
  update | call neomake#Make(0, enabled_makers) | echom "running: " . cmd
endfunction
command! -complete=file -nargs=? -bang Rubocop call s:Rubocop(<q-args>, <bang>0)

function! s:Format() range
  let spaces = indent(a:firstline)
  let prettier = 'prettier --no-config --stdin --add-trailing-commas --parser ' . &ft . ' --print-width ' . string(120 - spaces)
  if line("'<")
    let pos = "'<,'>"
  else
    let pos = '.'
  endif
  let cmd = "keepjumps " . pos . "! " . prettier . " | sed 's/^/" . repeat(' ', spaces) . "/'"
  exe cmd
endfunction
command! -range Format <line1>,<line2>call s:Format()
