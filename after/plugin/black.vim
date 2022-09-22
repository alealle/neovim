"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :> Black
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python Black format on save
augroup Python
    autocmd!BufWritePre *.py
    au BufWritePre *.py exec ':Black'
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


