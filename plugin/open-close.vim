" Title:        open-close.vim
" Description:  A plugin to improve the experience of opening and closing vim
" Last Change:  09 Apr 2023
" Maintainer:   Aaron Lichtman <https://github.com/alichtman>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:open_close_plugin")
    finish
endif
let g:open_close_plugin = 1

function! ToggleFileTree() abort
    if exists("g:open_close_use_NERDTree")
        :NERDTreeToggle
    elseif exists("g:open_close_use_CHADTree")
        :CHADopen
    else
        " Set default to CHADTree
        :CHADopen
    endif
    :AirlineRefresh
endfunction

if !exists("g:open_close_dont_remap_toggle_file_tree")
    nnoremap <C-n> :call ToggleFileTree()<CR>
endif

augroup AutoCloseVim
    autocmd!
    " Close vim if the quickfix window is the only window visible (and only tab)
    " https://stackoverflow.com/a/7477056
    autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | quit | endif
    " Close vim if only thing remaining is NERDTree
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | quit | endif
    " Close vim if only thing remaining is CHADTree
    autocmd BufEnter * if (winnr("$") == 1 && &filetype == "CHADTree") | quit! | endif
    " CLose vim if the only thing remaining is an empty buffer with no type
    " autocmd BufEnter * if (winnr("$") == 1 && &buftype == "" ) | quit! | endif
augroup END

augroup MakeFoldsPersistent
    autocmd!
    autocmd BufWinLeave * silent! mkview
    autocmd BufWinEnter * silent! loadview
augroup END

augroup RestoreCursorPositionWhenOpeningFile
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   execute "normal! g`\"" |
                \ endif
augroup END

augroup VimStartupSequence
    autocmd!
    " If opening vim without a file arg, open startify and NERDTree
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | call ToggleFileTree() | endif
    " Automatically install missing plugins
    autocmd VimEnter *
                \   if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
                \ |   PlugInstall --sync | q
                \ | endif
augroup END

" After opening a file, set working dir to the same as that file so relative
" paths will work nicely.
augroup SetWorkingDirForCurrentWindow
    autocmd!
    autocmd BufEnter * silent! lcd %:p:h
augroup END

" vim: et ts=4 sw=4 sts=4
