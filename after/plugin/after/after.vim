"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Author:
"       Alessandro Alle
"
" This file is necessary because vim overwrites any formatoptions
" set in init.vim when loading my plugins, since plugins are
" loaded after loading init.vim in vim start up process.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable comment sign insertion in a new line after C-r in a comment line
set formatoptions=jcql
" echom 'carregado'
" format rust on autosave
let g:rustfmt_autosave = 1
