if exists("current_compiler")
  finish
endif
let current_compiler = "mvn"

"let s:cpo_save = &cpo
"set cpo-=C
let s:old_errorformat = &errorformat

CompilerSet makeprg=mvn
CompilerSet errorformat=\ \ %f:%l\ %m

"let &cpo = s:cpo_save
"unlet s:cpo_save
let &errorformat = s:old_errorformat
unlet s:old_errorformat

" vim: nowrap sw=2 sts=2 ts=8:
