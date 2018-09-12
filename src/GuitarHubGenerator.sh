#!/bin/bash

echo '
--> Generating GuitarHubAlphabeticNoteNames.pdf <--'
arara GuitarHubAlphabeticNoteNames.tex
mv GuitarHubAlphabeticNoteNames.pdf ../GuitarHubAlphabeticNoteNames.pdf

echo '
--> Generating GuitarHubLyrics.pdf <--'
arara GuitarHubLyrics.tex
mv GuitarHubLyrics.pdf ../GuitarHubLyrics.pdf

echo '
--> Generating GuitarHubSolfegeNoteNames.pdf <--'
arara GuitarHubSolfegeNoteNames.tex
mv GuitarHubSolfegeNoteNames.pdf ../GuitarHubSolfegeNoteNames.pdf
