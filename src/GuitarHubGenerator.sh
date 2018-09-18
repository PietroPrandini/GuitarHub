#!/bin/bash

echo '
--> Generating GuitarHubAlphabeticNoteNames.pdf <--'
arara GuitarHubAlphabeticNoteNames.tex

echo '
--> Generating GuitarHubLyrics.pdf <--'
arara GuitarHubLyrics.tex

echo '
--> Generating GuitarHubSolfegeNoteNames.pdf <--'
arara GuitarHubSolfegeNoteNames.tex

echo '
--> Generating GuitarHubAlphabeticNoteNamesBooklet.pdf'
arara GuitarHubAlphabeticNoteNamesBooklet.tex

echo '
--> Generating GuitarHubLyricsBooklet.pdf'
arara GuitarHubLyricsBooklet.tex

echo '
--> Generating GuitarHubSolfegeNoteNamesBooklet.pdf'
arara GuitarHubSolfegeNoteNamesBooklet.tex

#	Moving the files generated
mv GuitarHubAlphabeticNoteNames.pdf ../GuitarHubAlphabeticNoteNames.pdf
mv GuitarHubSolfegeNoteNames.pdf ../GuitarHubSolfegeNoteNames.pdf
mv GuitarHubLyrics.pdf ../GuitarHubLyrics.pdf
mv GuitarHubAlphabeticNoteNamesBooklet.pdf ../GuitarHubAlphabeticNoteNamesBooklet.pdf
mv GuitarHubLyricsBooklet.pdf ../GuitarHubLyricsBooklet.pdf
mv GuitarHubSolfegeNoteNamesBooklet.pdf ../GuitarHubSolfegeNoteNamesBooklet.pdf
echo '
--> pdf generated is moved to the main directory of GuitarHub
'
