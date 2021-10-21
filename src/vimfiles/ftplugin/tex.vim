" Vim filetype plugin file
" Language:	LaTeX Songbook
" Maintainer:	Kevin Hamlen
" Last Change:	2008 February 22

if exists("b:did_ftplugin_extra")
  finish
endif

let b:did_ftplugin_extra = 1

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

if (executable('generate') || executable('gmake')) && !exists("g:songbookmenus") && (join(getline(1,30)) =~ '.*\\usepackage.*songs.*')
  let g:songbookmenus = 1
  amenu <silent> 600.100 SongBoo&k.&Generate :call <SID>GenerateSongbook()<CR>
  tmenu SongBoo&k.&Generate Save file and generate a song book pdf
  amenu icon=sgen.bmp 1.35 ToolBar.SGen :call <SID>GenerateSongbook()<CR>
  tmenu ToolBar.SGen Save file and generate a song book pdf
endif

