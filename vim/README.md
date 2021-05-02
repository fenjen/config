# Introduction
This vimrc is basically for gvim on Windows (hence the name "_vimrc"). I'd
however recommend most of these settings for all vim versions. In this
document, I'll give a short description for parts of my configuration. The
vimrc contains more detailed information about it. All source code lines here
are copied from my vimrc.

# Features
There is more configuration in the vimrc file. Most of it isn't worth
mentioning.

## Settings
See vim help for setting descriptions. (In gvim, press <kbd>k</kbd> for quick
lookup of descriptions and <kbd>Ctrl</kbd>+<kbd>w</kbd> <kbd>c</kbd> for
closing the help window.)

### Unix and Windows
vim is available almost everywhere, so vim in Windows should behave like the
Unix version. 
```vim
behave xterm
```
I also `set go=gcrLteAb` to make it more similar to a terminal version. For
example, I hide the menu because.. who needs menus in vim anyways when the hand
is on keyboard.

In Windows, I prefer using the Windows clipboard for default:
```vim
set clipboard=unnamed               " Always use * register for clipboard operations
```
Select text with left mouse, and <kbd>y</kbd> for yank or <kbd>p</kbd> /
<kbd>P</kbd> for pasting.

### Window size
Make the window bigger (or maximized).
```vim
set lines=40 columns=160            " Create a bigger window when starting
" au GUIEnter * simalt ~x           " Maximize vim when starting
nno <C-z> :if &lines==40 \| simalt ~x \| else \| set lines=40 columns=160 \| endif<CR>
```
Toggle between maximized window and 40/160 with <kbd>Ctrl</kbd>+<kbd>z</kbd>.
(Of course, this makes only sense in GUI versions.)

### Working with buffers
I recommend the following setting for everyone. If it is not set, I'm more or
less unable to use vim effectively and change it immediately.
```vim
set hidden                          " Automatically set buffer hidden when editing new buffers
```
vim asks about unsaved buffers before leaving anyways.

The next two mappings enable one to cycle through buffers easily. The keys
<kbd>Ctrl</kbd>+<kbd>PageDown</kbd> and <kbd>Ctrl</kbd>+<kbd>PageUp</kbd> are
used by vim for cycling through _tabs_, so I check the number of tabs and keep
the default behaviour when there's more than one tab open.
```vim
" Bind <C-PageUp> and <C-PageDown> to cycling buffers if there's only one tab
nno <C-PageUp>   :silent if tabpagenr("$") == 1 \| bp \| else \| tabp \| endif<CR>
nno <C-PageDown> :silent if tabpagenr("$") == 1 \| bn \| else \| tabn \| endif<CR>
```

### Searching
I'm working with `ignorecase smartcase`: In searches, case is only considered
when there's at least one uppercase letter in the search pattern. With
<kbd>Ctrl></kbd>+<kbd>k</kbd>, I'm able to toggle highlighting results.
```vim
set showmatch                       " Show matching brackets
set incsearch                       " Search for pattern while typing
set hlsearch                        " Highlight search matches (toggle with <C-k>)
set ignorecase                      " Don't consider case when searching (with smartcase exception)
set smartcase                       " Only consider case when there's an upper case letter in search string
nno <C-k> :set hls!<CR>|            " Toggle hightlighting last search matches
```

### Debatable settings
Settings about automatic indentation and indentation chars depend on personal
preferences. I use tabs. For many reasons.

## Commands
When using split windows, e. g. for file diffs, `:bd` closes the window along
with the buffer. In my opinion, that's an undesirable behaviour. `:Bd` deletes
only the current buffer, but doesn't destroy the split window arrangement.
```vim
command Bd bp\|bd \#
```

## Mappings
Additionally to the above mentioned mappings, here are some more:
### Insert above/below
I'd like to be able to insert a new line below/above the current line and place
the cursor accordingly. (Note that <kbd>Shift</kbd>+<kbd>Enter</kbd> will not
insert a linebreak at cursor position, but create a new line below cursor.)
```vim
" Insert line below and above
ino <S-CR> <ESC>o
ino <C-S-CR> <ESC>O
```

## Autocommands
### Detect filetype
vim should redetect the filetype after saving.
```vim
au BufWritePost * filetype detect                       " Detect filetype after saving file
```
### Place cursor on last edit position
I always like to have my cursor where I left the file last time. I usually
don't search for files in a file system explorer. I find it easier to just open
vim and press <kbd>Ctrl</kbd>+<kbd>o</kbd>.
```vim
autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
```
### Wipe empty buffers
This autocommand wipes empty buffers from the list of open buffers. Very handy!
```vim
" Wipe empty buffers e. g. when opening a buffer
function! CleanEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")')
    if !empty(buffers)
        exe 'bw ' . join(buffers, ' ')
    endif
endfunction
au BufEnter * silent call CleanEmptyBuffers()
```
