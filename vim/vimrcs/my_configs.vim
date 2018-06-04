"""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""
 
" Enable line numbers
"set number
 
" Toggle line wrap
map <leader>f :set wrap!<cr>
 
" Change directory to current file's path
"map <leader>cd :cd %:p:h<cr>
 
" Toggle line numbers
map <leader>n :set number!<cr>
 
" Create new vertical spit
noremap <C-n> <C-w>v<cr>
 
" Change keyword lookup from K to ,k
nnoremap <leader>k K
 
"" Change high & low to J & K
"nnoremap J L
"nnoremap K H
" 
"" Move tabs
"nnoremap H gT
"nnoremap L gt
 
" Map refreshing of syntax
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
 
" Show explorer
noremap <leader>e <Esc>:Explore<cr>
 
" Open file under cursor
map <F8> :let mycurf=expand("<cfile>")<CR>:execute("e ".mycurf)<CR>
 
" Refresh file
map <leader>rr :e!<CR>
 
" Source vimrc
 
" Edit vimrc

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
 
 
 
"""""""""""""""""""""""""
" Settings
"""""""""""""""""""""""""
 
" Don't wrap lines
set nowrap
 
" Set menu to match up to the longest common string
set wildmode=list:longest
 
" Set font
set guifont=Monospace\ 10
 
" Height of the command bar
set cmdheight=1
 
" Highlight current line
set cursorline
 
" disable auto comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
 
try
    colorscheme pablo
catch
endtry


"""""""""""""""""""""""""
" Color
"""""""""""""""""""""""""
colorscheme gruvbox
