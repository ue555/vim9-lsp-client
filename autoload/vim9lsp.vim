" vim9lsp.vim - Vim9 LSP autoload functions
" Maintainer: Vim Community
" License: MIT

let s:setup_done = 0
let s:vimlsp_registered = 0
let s:server_path = ''

" Main setup function
function! vim9lsp#Setup() abort
  if s:setup_done
    return
  endif

  " Find server binary
  let l:server_path = vim9lsp#FindServer()
  if empty(l:server_path)
    echohl WarningMsg
    echom 'vim9-lsp-server not found. Run :Vim9LspInstall to install.'
    echohl None
    return
  endif

  " Setup LSP client based on availability
  if vim9lsp#HasVim9LSP()
    call vim9lsp#SetupVim9LSP(l:server_path)
    let s:setup_done = 1
  elseif vim9lsp#HasVimLsp()
    call vim9lsp#SetupVimLsp(l:server_path)
    let s:setup_done = 1
  else
    echohl ErrorMsg
    echom 'No LSP client found. Please install vim-lsp or use Vim 9.1+'
    echohl None
  endif
endfunction

" Find server binary path
function! vim9lsp#FindServer() abort
  let l:server_dir = get(g:, 'vim9_lsp_server_path', expand('~/.vim/pack/vpm/start/vim9-lsp-server'))
  let l:server_binary = l:server_dir . '/out/server.js'

  if !executable('node')
    echohl ErrorMsg
    echom 'Node.js is not installed or not in PATH'
    echohl None
    return ''
  endif

  if !filereadable(l:server_binary)
    return ''
  endif

  return l:server_binary
endfunction

" Check if Vim 9.1+ built-in LSP is available
function! vim9lsp#HasVim9LSP() abort
  return has('vim9script') && exists('*lsp#lsp#AddServer')
endfunction

" Check if vim-lsp is available
function! vim9lsp#HasVimLsp() abort
  return exists('g:lsp_loaded') || exists('*lsp#register_server')
endfunction

" Setup Vim 9.1+ built-in LSP
function! vim9lsp#SetupVim9LSP(server_path) abort
  try
    " Use Vim9 script for built-in LSP setup
    execute 'vim9script'

    var lspServers = [{
      name: 'vim9-lsp',
      filetype: ['vim'],
      path: 'node',
      args: [a:server_path, '--stdio'],
      syncInit: v:true
    }]

    augroup Vim9LSPClient
      autocmd!
      autocmd VimEnter * call lsp#lsp#AddServer(lspServers)
    augroup END

  catch
    echohl ErrorMsg
    echom 'Failed to setup Vim9 built-in LSP: ' . v:exception
    echohl None
  endtry
endfunction

" Setup vim-lsp client
function! vim9lsp#SetupVimLsp(server_path) abort
  if !vim9lsp#HasVimLsp()
    return
  endif

  let s:server_path = a:server_path

  augroup Vim9LSPClient
    autocmd!
    autocmd User lsp_setup call s:RegisterVimLsp(s:server_path)
  augroup END

  if exists('g:lsp_loaded')
    call s:RegisterVimLsp(s:server_path)
  endif

endfunction

" Register server with vim-lsp
function! s:RegisterVimLsp(server_path) abort
  " Check if already registered (using script-local flag)
  if s:vimlsp_registered
    return
  endif

  call lsp#register_server({
    \ 'name': 'vim9-lsp-server',
    \ 'cmd': {server_info -> ['node', a:server_path, '--stdio']},
    \ 'allowlist': ['vim'],
    \ 'workspace_config': {},
    \ })

  let s:vimlsp_registered = 1
endfunction

" Install/Update server using Go setup tool
function! vim9lsp#InstallServer() abort
  let l:plugin_dir = expand('<sfile>:p:h:h')
  let l:setup_binary = l:plugin_dir . '/bin/vim9-lsp-setup'
  let l:install_dir = fnamemodify(get(g:, 'vim9_lsp_server_path', expand('~/.vim/pack/vpm/start')), ':h')

  " Check if setup binary exists
  if !executable(l:setup_binary)
    echohl ErrorMsg
    echom 'Setup binary not found. Please run: cd ' . l:plugin_dir . ' && make'
    echohl None
    return
  endif

  echom 'Installing vim9-lsp-server to ' . l:install_dir . '...'

  " Run setup tool
  let l:output = system(l:setup_binary . ' ' . shellescape(l:install_dir))

  if v:shell_error != 0
    echohl ErrorMsg
    echom 'Installation failed:'
    echom l:output
    echohl None
  else
    echo l:output
    echom 'Installation completed! Restart Vim to use the LSP server.'
  endif
endfunction

" Get server status
function! vim9lsp#Status() abort
  let l:server_path = vim9lsp#FindServer()

  echo '=== Vim9 LSP Status ==='
  echo 'Node.js: ' . (executable('node') ? system('node --version') : 'Not found')
  echo 'Server: ' . (empty(l:server_path) ? 'Not installed' : l:server_path)

  if vim9lsp#HasVim9LSP()
    echo 'LSP Client: Vim 9.1+ built-in'
  elseif vim9lsp#HasVimLsp()
    echo 'LSP Client: vim-lsp'
  else
    echo 'LSP Client: Not found'
  endif

  echo 'Setup done: ' . (s:setup_done ? 'Yes' : 'No')
endfunction

" User command to check status
command! Vim9LspStatus call vim9lsp#Status()
