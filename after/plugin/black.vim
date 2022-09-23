"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Black
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python Black format on save
augroup Python
    autocmd!BufWritePre *.py
    au BufWritePre *.py exec ':Black'
    au BufWritePre *.py echom 'Formatted with Black'
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


