set number
syntax on
set autoindent
set smartindent
set ts=2
set shiftwidth=2
set expandtab
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
hi Normal guibg=NONE ctermbg=NONE
set ttimeout
set ttimeoutlen=0
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
packadd! vimspector
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
autocmd VimEnter * silent exec "startinsert"
nmap <Leader><F9> <Plug>VimspectorRunToCursor

