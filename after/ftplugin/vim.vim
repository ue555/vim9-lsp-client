" vim.vim - Vim filetype settings for LSP
" Maintainer: Vim Community
" License: MIT

" Only load once per buffer
if exists('b:did_vim9_lsp_ftplugin')
  finish
endif
let b:did_vim9_lsp_ftplugin = 1

" Enable LSP features for vim files
if vim9lsp#HasVimLsp()
  " vim-lsp specific settings
  setlocal omnifunc=lsp#complete

  " Key mappings for vim-lsp
  if get(g:, 'vim9_lsp_enable_mappings', 1)
    nnoremap <buffer> <silent> gd :LspDefinition<CR>
    nnoremap <buffer> <silent> K :LspHover<CR>
    nnoremap <buffer> <silent> <leader>rn :LspRename<CR>
    nnoremap <buffer> <silent> <leader>f :LspDocumentFormat<CR>
    nnoremap <buffer> <silent> gr :LspReferences<CR>
  endif
elseif vim9lsp#HasVim9LSP()
  " Vim 9.1+ built-in LSP settings
  " Key mappings are typically set globally by Vim's LSP config

  if get(g:, 'vim9_lsp_enable_mappings', 1)
    nnoremap <buffer> <silent> gd :LspGotoDefinition<CR>
    nnoremap <buffer> <silent> K :LspHover<CR>
    nnoremap <buffer> <silent> <leader>rn :LspRename<CR>
    nnoremap <buffer> <silent> <leader>f :LspFormat<CR>
    nnoremap <buffer> <silent> gr :LspShowReferences<CR>
  endif
endif
