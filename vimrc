call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"Shortcut to rapidly toggle 'set list'
nmap <leader>l :set list!<CR>

"Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

set ts=2 sw=2 sts=2 expandtab
if has("autocmd")
  " Enable file type detection
  filetype on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  autocmd bufwritepost .vimrc source $MYVIMRC
endif

"Strip trailing whitespace
autocmd BufWritePre *.erb,*.js :call <SID>StripTrailingWhitespaces()
"nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

color blackboard

map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>v :tabedit $MYVIMRC<CR>
set number
set linebreak
set columns=200

"Bubbling
nmap <C-k> ddkP
nmap <C-j> ddp
nmap <C-l> dw/ <CR>p
nmap <C-h> dw? <CR>np
vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

"Automatically align cucumber outlines
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

"Gundo
nnoremap <F5> :GundoToggle<CR>
