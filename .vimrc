syntax on
set autoread
set number
set autoindent
set smartindent
set ts=4
set shiftwidth=4
set expandtab
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
"hi Normal guibg=NONE ctermbg=NONE
set ttimeout
set ttimeoutlen=0
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
autocmd VimEnter * silent exec 'call feedkeys("I\<esc>")'

map <F5> :wa <bar>!clear && ./s_format.sh && ./s_compile.sh && clear && ./s_run.sh<CR>
map <F6> :wa <bar>!clear && ./s_format.sh && ./s_compile.sh<CR>
map <F7> :wa <bar>!clear && ./s_format.sh<CR>

call plug#begin()
  Plug 'preservim/nerdtree'
call plug#end()

"packadd! vimspector
"let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
"nmap <Leader><F9> <Plug>VimspectorRunToCursor

highlight VertSplit guibg=Orange guifg=Black ctermbg=6 ctermfg=0
hi statusline ctermbg=6 ctermfg=0
hi statuslinenc ctermbg=6 ctermfg=0
