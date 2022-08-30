syntax on
set autoread
set number
set autoindent
set smartindent
set ts=4
set shiftwidth=4
set expandtab
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set ttimeout
set ttimeoutlen=0
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

autocmd VimEnter * silent exec 'call feedkeys("I\<esc>")'
"autocmd FocusGained,BufEnter * :silent! e 
"autocmd FocusLost,WinLeave * :silent! w

map <F5> :wa <bar>!clear && ./s_compile.sh && clear && ./s_run.sh<CR>
map <F6> :wa <bar>!clear && ./s_compile.sh<CR>
map <F7> :wa <bar>!clear && ./s_format.sh<CR><CR>

call plug#begin()
  Plug 'preservim/nerdtree'
call plug#end()

highlight vertsplit guibg=Orange guifg=Black ctermbg=6 ctermfg=0
highlight statusline ctermbg=6 ctermfg=0
highlight statuslinenc ctermbg=6 ctermfg=0
