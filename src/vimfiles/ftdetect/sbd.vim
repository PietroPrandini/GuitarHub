au BufRead,BufNewFile *.sbd set filetype=songbook | let b:spellbuf = -1
au BufUnload *.sbd if bufexists(b:spellbuf) | exe "bunload " . b:spellbuf | endif
