" Open NERDTree automatically when no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

let g:deoplete#enable_at_startup = 1 " Autocomplete
let test#strategy = "neovim" " Use nvim terminal for tests
let g:DevIconsEnableFoldersOpenClose = 1 " Use folder icons in file tree
let g:airline_powerline_fonts = 1 " Use powerline fonts in status bar
let g:gruvbox_italic = 1 " Use italics in gruvbox theme
