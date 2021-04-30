" General
setlocal number
colorscheme slate
setlocal suffixesadd+=.jsx,.js,.css

" Indentation
" - Reindent lines with }
" - Reindent pasted lines
ino <buffer> } }<C-o>mm<C-o>=iB<C-o>`m<right>
nno <buffer> p pmm=`]`m
nno <buffer> P Pmm=`]`m

" Keys
" - Save: <F9>
nno <buffer> <F9> <ESC>:silent! :w!<CR>

" Leave out node_modules on vimgrep This is not set local only, because
" various other files are edited. We'll just leave them out as soon as a
" javascript file is edited.
set wildignore=*/node_modules/*,*/target/*,*/tmp/*

" Highlight word under cursor (CursorMoved is inperformant)
" updatetime affects write swap file delay and cursorhold trigger (default: 4000ms)
setlocal updatetime=300
highlight WordUnderCursor cterm=underline gui=underline
autocmd CursorHold * call HighlightCursorWord()
function! HighlightCursorWord()
	" if hlsearch is active, don't overwrite it!
	let cword = expand('<cword>')
	if match(cword, getreg('/')) == -1
		exe printf('match WordUnderCursor /\V\<%s\>/', escape(cword, '/\'))
	else 
		" When cursor is on search word, remove previous match
		exe printf('match WordUnderCursor //')
	endif
endfunction

" Rename cursor word with Alt+Shift+R
function! RenameCursorWord()
	call SaveView()
	let cword = expand('<cword>')
	let nword = input('Enter new name: ', cword)
	redraw
	exe printf('%%s/\V\<%s\>/%s/', escape(cword, '/\'), escape(nword, '/\'))
	call RestoreView()
endfunction
function! SaveView()
	let s:view = winsaveview()
endfunction
function! RestoreView()
	call winrestview(s:view)
endfunction
nno <buffer> <A-S-r> :call RenameCursorWord()<CR>
