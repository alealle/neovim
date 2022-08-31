nnoremap <leader>f :call FoldColumnToggle()<cr>
nnoremap <leader>qq :call QuickfixToggle()<cr>
let g:quickfix_is_open=0


function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
    echom &foldcolumn
endfunction

function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open=0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open=1
    endif
endfunction
