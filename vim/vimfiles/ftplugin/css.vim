" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
	finish
endif

" Similar to javascript features
runtime! ftplugin/javascript.vim
