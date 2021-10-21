" Vim filetype plugin file
" Language:	LaTeX Songbook
" Maintainer:	Kevin W. Hamlen
" Last Change:	2008 August 4

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

if !exists("*<SID>GenerateSongbook")
  function <SID>GenerateSongbook()
    if &modified
      confirm w
    endif
    if has("unix")
      silent !gmake
    else
      silent !generate
    endif
  endfunction
endif
if exists(":SBgen")!=2
  command SBgen :call <SID>GenerateSongbook()
endif

if !exists("*<SID>QuickChord")
  function <SID>QuickChord(tonic)
    let l = getline('.')
    let c = col('.')
    if match(strpart(l,0,c-1),'\\\%(\[[^]]*\|m\=ch{[^}]*\)$') >= 0
      if (strpart(l,c-2,1) == "/") || (strpart(l,c-2,1) == "[")
        return toupper(a:tonic)
      else
        return a:tonic
      endif
    else
      if mode() == "R"
        return a:tonic
      else
        for lig in ['ffi','ffl','ff','fi','fl']
          let m = match(strpart(l,c-strlen(lig),(strlen(lig)-1)*2),lig)
	  if m >= 0
            return repeat("\<Left>",strlen(lig)-m-1) . "\\ch{}{" . strpart(lig,0,strlen(lig)-m-1) . "}{" . strpart(lig,strlen(lig)-m-1,m+1) . "}{" . repeat("\<Right>",strlen(lig)) . "}" . repeat("\<Left>",strlen(lig)*2+7) . toupper(a:tonic)
	  endif
	endfor
        return "\\\[]\<Left>" . toupper(a:tonic)
      endif
    endif
  endfunction
endif

let b:qcmode = 0

if !exists("*<SID>QuickChordsOn")
  function <SID>QuickChordsOn()
    if exists("b:qcmode")
      for tonic in ['a','b','c','d','e','f','g']
        execute "inoremap <buffer> <expr> " . tonic . " <SID>QuickChord(\"" . tonic . "\")"
        execute "inoremap <buffer> <expr> " . toupper(tonic) . " <SID>QuickChord(\"" . toupper(tonic) . "\")"
      endfor
      if b:qcmode == 0
        aunmenu SongBoo&k.&Quick\ Chords\ on
	aunmenu ToolBar.QC
        amenu <silent> 600.150 SongBoo&k.&Quick\ Chords\ off :call <SID>QuickChordsToggle()<CR>
        tmenu SongBoo&k.&Quick\ Chords\ off Turn off quick chord-entry mode
        amenu icon=qcon 1.285 ToolBar.QC :call <SID>QuickChordsToggle()<CR>
        tmenu ToolBar.QC Turn off quick chord-entry mode
      endif
      let b:qcmode = 1
      echomsg "Quick-chords mode activated"
      if &showmode > 0
        let b:qcmode = 2
        set noshowmode
        aug QC
        au QC BufEnter <buffer> set noshowmode
        au QC InsertEnter <buffer> redraw | echohl ModeMsg | echo "-- QUICK CHORDS MODE" . ((mode()=="R") ? ": REPLACE --" : " --") | echohl None
        au QC CursorMovedI <buffer> redraw | echohl ModeMsg | echo "-- QUICK CHORDS MODE" . ((mode()=="R") ? ": REPLACE --" : " --") | echohl None
        au QC InsertChange <buffer> redraw | echohl ModeMsg | echo "-- QUICK CHORDS MODE" . ((mode()=="R") ? " --" : ": REPLACE --") | echohl None
        au QC InsertLeave <buffer> echo " "
        au QC BufLeave <buffer> echo " " | set showmode
        aug END
      endif
    endif
  endfunction
endif
if exists(":SBqcon")!=2
  command SBqcon :call <SID>QuickChordsOn()
endif

if !exists("*<SID>QuickChordsOff")
  function <SID>QuickChordsOff()
    if exists("b:qcmode") && (b:qcmode > 0)
      for tonic in ['a','b','c','d','e','f','g']
        execute "iunmap <buffer> " . tonic
        execute "iunmap <buffer> " . toupper(tonic)
      endfor
      if b:qcmode > 1
        au! QC
        set showmode
      endif
      aunmenu SongBoo&k.&Quick\ Chords\ off
      aunmenu ToolBar.QC
      amenu <silent> 600.150 SongBoo&k.&Quick\ Chords\ on :call <SID>QuickChordsToggle()<CR>
      tmenu SongBoo&k.&Quick\ Chords\ on Turn on quick chord-entry mode
      amenu icon=qcoff 1.285 ToolBar.QC :call <SID>QuickChordsToggle()<CR>
      tmenu ToolBar.QC Turn on quick chord-entry mode
      let b:qcmode = 0
      echomsg "Quick-chords mode deactivated"
    endif
  endfunction
endif
if exists(":SBqcoff")!=2
  command SBqcoff :call <SID>QuickChordsOff()
endif

if !exists("*<SID>QuickChordsToggle")
  function <SID>QuickChordsToggle()
    if exists("b:qcmode")
      if b:qcmode > 0
        call <SID>QuickChordsOff()
      else
        call <SID>QuickChordsOn()
      endif
    endif
  endfunction
endif

if !exists("*<SID>CorrectLigatures")
  function <SID>CorrectLigatures()
    if search('f\{1,2}|\=\\\[\([^[\]]*\)\]\(fi\|fl\|f\|i\|l\)','w')
      %s/\(f\%(f\%(|\=\\\[[^[\]]*\]\%(i\|l\)\)\@=\)\=\)\(|\=\)\\\[\([^[\]]*\)\]\(fi\|fl\|f\|i\|l\)/\=((submatch(2)=='|') ? '\\mch{' : '\\ch{') . submatch(3) . '}{' . submatch(1) . '}{' . submatch(4) . '}{' . submatch(1) . submatch(4) . '}'/g
    else
      redraw
      echomsg 'No ligatures need to be corrected.'
    endif
    sleep
  endfunction
endif
if exists(":SBligs")!=2
  command SBligs :call <SID>CorrectLigatures()
endif

if !exists("*<SID>UpdateSyntax")
  function s:expandif(s1,s2)
    return ((a:s2=='') ? '' : ('  ' . a:s1 . '={' . substitute(a:s2,'\\','\\\\','g') . '}'))
  endfunction
  function s:catlist(slist)
    let x = ''
    for item in a:slist
      let x = ((item=='') ? x : ((x=='') ? item : (x.','.item)))
    endfor
    return x
  endfunction
  function <SID>UpdateSyntax()
    if search('\\beginsong\%(\_s*{[^{}]*}\)\{4}','w')
      %s/\\beginsong\_s*{\([^{}]*\)}\_s*{\([^{}]*\)}\_s*{\([^{}]*\)}\_s*{\([^{}]*\)}/\='\\beginsong{'.substitute(submatch(1),'\\','\\\\','g').'}' . ((submatch(2).submatch(3).submatch(4) == '') ? '' : ('[' . s:catlist([s:expandif('by',submatch(3)), s:expandif('sr',submatch(2)), s:expandif('cr',submatch(4))]) . ']'))/g
    else
      redraw
      echomsg 'No legacy syntax needs updating.'
    endif
    sleep
  endfunction
endif
if exists(":SBupdate")!=2
  command SBupdate :call <SID>UpdateSyntax()
endif

if !exists("*<SID>SpellCheck")
  function <SID>SpellCheck()
    if version < 700
      echohl ErrorMsg | echomsg "Need Vim 7.0 or above"
      return
    endif
    if &filetype == "songbook"
      if exists("b:sourcebuf")
        echohl ErrorMsg | echomsg "Spellcheck window is already open"
        return
      endif
    else
      echohl ErrorMsg | echomsg "Current window is not a songbook window"
      return
    endif
    if bufexists(b:spellbuf)
      exe bufwinnr(b:spellbuf) . "wincmd w"
      return
    endif
    let b1 = bufnr("%")
    let l1 = line(".")
    go
    new
    call setbufvar(b1,"spellbuf",bufnr("%"))
    let b:sourcebuf = b1
    setlocal bufhidden=unload buftype=nofile
    call setline(1,getbufline(b1,1,"$"))
    sil %s/\\\[[^[\]]*\]//ge
    sil %s/\\m\=ch\%({[^{}]*}\)\{3}{\([^{}]*\)}/\1/ge
    sil %s/\\gtab\%({[^{}]*}\)\{2}//ge
    sil %s/|//ge
    sil %s/\^//ge
    sil %s/\\mbar\%({[^{}]*}\)\{2}//ge
    sil %s/^\zs\s*//ge
    noh
    go
    call setbufvar(b1,"&scrollbind",1)
    syncbind
    exe l1
    let ll = split(&spelllang,",")
    if index(ll,"songbook") < 0
      let ll = add(ll,"songbook")
    endif
    exe "setlocal filetype=songbook readonly nomodifiable scrollbind spell spellcapcheck= spelllang=" . join(ll,",")
    setlocal statusline=%<Spell-checking\ Window\ [read-only]%=%-14.(%l,%c%V%)\ %P
    set guioptions-=r guioptions-=R guioptions-=l guioptions-=L
    au BufUnload <buffer> call setbufvar(b:sourcebuf,"spellbuf",-1)
    au BufUnload <buffer> set guioptions+=rL
    nnoremap <buffer> <silent> <special> <Space> <Esc>:call <SID>SpellCorrect()<CR>
    nmap <buffer> <Tab> ]s
    nmap <buffer> <S-Tab> [s
    if &insertmode > 0
      inoremap <buffer> <silent> <special> <Space> <Esc>:call <SID>SpellCorrect()<CR>
      imap <buffer> <Tab> <Esc>]s
      imap <buffer> <S-Tab> <Esc>[s
    endif
    echomsg "Read-only spelling window opened."
  endfunction
endif
if exists(":SBspell")!=2
  command SBspell :call <SID>SpellCheck()
endif

if !exists("*<SID>SpellCorrect")
  function <SID>SpellCorrect()
    let [bufnum, lnum, cnum, off] = getpos(".")
    exe bufwinnr(b:sourcebuf) . "wincmd w"
    let s = getline(lnum) . "\r"
    let s = substitute(s, '\(\\m\=ch\%({[^{}]*}\)\{3}{\%([^{}]*\)\)}', '\1\b', "g")
    let i = matchend(s, '^\%(|\|\^\|\s\|\\\[[^[\]]*\]\|\\m\=ch\%({[^{}]*}\)\{3}{\s*\b\|\\gtab\%({[^{}]*}\)\{2}\|\\mbar\%({[^{}]*}\)\{2}\)*\%(\%(|\|\^\|\\\[[^[\]]*\]\|\\m\=ch\%({[^{}]*}\)\{3}{\|\b\|\\gtab\%({[^{}]*}\)\{2}\|\\mbar\%({[^{}]*}\)\{2}\)*\_.\)\{' . cnum . '}')
    call cursor(lnum, max([1, i]))
    if &insertmode > 0
      startinsert
    endif
  endfunction
endif

if !exists("*<SID>SBDCheck")
  function <SID>SBDCheck()
    set efm=%l:%c:\ %m
    if &modified
      confirm w
    endif
    let f = bufname("%")
    if has("unix")
      silent !gmake sbdcheck
    else
      silent exe "!generate sbdcheck ".f
    endif
    let d = strridx(f,".")
    if d>=0
      let f = strpart(f,0,d)
    endif
    let f = f.".hyp"
    if filereadable(f)
      exe "cfile ".f
      cope
      wincmd p
    endif
  endfunction
endif
if exists(":SBhyphens")!=2
  command SBhyphens :call <SID>SBDCheck()
endif


if !exists("g:songbookmenus")
  let g:songbookmenus = 1
  amenu <silent> 600.100 SongBoo&k.&Generate :call <SID>GenerateSongbook()<CR>
  tmenu SongBoo&k.&Generate Save file and generate a song book pdf
  amenu icon=sgen 1.35 ToolBar.SGen :call <SID>GenerateSongbook()<CR>
  tmenu ToolBar.SGen Save file and generate a song book pdf
  amenu <silent> 600.150 SongBoo&k.&Quick\ Chords\ on :call <SID>QuickChordsToggle()<CR>
  tmenu SongBoo&k.&Quick\ Chords\ on Turn on quick chord-entry mode
  amenu icon=qcoff 1.285 ToolBar.QC :call <SID>QuickChordsToggle()<CR>
  tmenu ToolBar.QC Turn on quick chord-entry mode
  amenu <silent> 600.200 SongBoo&k.Correct\ &Ligatures :call <SID>CorrectLigatures()<CR>
  tmenu SongBoo&k.Correct\ &Ligatures Fix chords that break ligatures
  if version >= 700
    amenu <silent> 600.300 SongBoo&k.&Spellcheck :call <SID>SpellCheck()<CR>
    tmenu SongBoo&k.Spellcheck Open a spell-checking window
  endif
  amenu <silent> 600.400 SongBoo&k.Check\ &Chord\ Placement :call <SID>SBDCheck()<CR>
  tmenu SongBoo&k.Check\ &Chord\ Placement Find chords at invalid hyphenation points
  amenu <silent> 600.900 SongBoo&k.&Update\ Syntax :call <SID>UpdateSyntax()<CR>
  tmenu SongBoo&k.&Update\ Syntax Update legacy songbook syntax
endif

set foldmethod=syntax
set foldlevel=100

