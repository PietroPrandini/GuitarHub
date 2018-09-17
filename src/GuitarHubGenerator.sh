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
--> Generating GuitarHubAlphabeticNoteNamesBrochure.pdf'
arara GuitarHubAlphabeticNoteNamesBrochure.tex

echo '
--> Generating GuitarHubLyricsBrochure.pdf'
arara GuitarHubLyricsBrochure.tex

echo '
--> Generating GuitarHubSolfegeNoteNamesBrochure.pdf'
arara GuitarHubSolfegeNoteNamesBrochure.tex

#	Moving the files generated
mv GuitarHubAlphabeticNoteNames.pdf ../GuitarHubAlphabeticNoteNames.pdf
mv GuitarHubSolfegeNoteNames.pdf ../GuitarHubSolfegeNoteNames.pdf
mv GuitarHubLyrics.pdf ../GuitarHubLyrics.pdf
mv GuitarHubAlphabeticNoteNamesBrochure.pdf ../GuitarHubAlphabeticNoteNamesBrochure.pdf
mv GuitarHubLyricsBrochure.pdf ../GuitarHubLyricsBrochure.pdf
mv GuitarHubSolfegeNoteNamesBrochure.pdf ../GuitarHubSolfegeNoteNamesBrochure.pdf
echo '
--> pdf generated is moved to the main directory of GuitarHub
'
