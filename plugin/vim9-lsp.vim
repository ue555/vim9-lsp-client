" vim9-lsp.vim - Vim9 LSP Client Plugin
" Maintainer: Vim Community
" License: MIT

if exists('g:loaded_vim9_lsp')
  finish
endif
let g:loaded_vim9_lsp = 1

" Allow user to disable auto-setup
if !exists('g:vim9_lsp_auto_setup')
  let g:vim9_lsp_auto_setup = 1
endif

" Default server installation path
if !exists('g:vim9_lsp_server_path')
  let g:vim9_lsp_server_path = expand('~/.vim/pack/vpm/start/vim9-lsp-server')
endif

" Setup server on VimEnter if auto-setup is enabled
augroup Vim9LSPSetup
  autocmd!
  if g:vim9_lsp_auto_setup
    autocmd VimEnter * call vim9lsp#Setup()
  endif
augroup END

" Command to manually setup the server
command! Vim9LspSetup call vim9lsp#Setup()

" Command to manually install/update the server
command! Vim9LspInstall call vim9lsp#InstallServer()
