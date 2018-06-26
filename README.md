# GuitarHub
Chords and Lyrics book.

## Porpouse
The primary aim of this project is to make a printable guitar chords book.

## Considerations
This book is firstly thinked for the guitarists that would like to have a chords book updatable every time with new songs without losing the formatting, the ordering and any other related problems.
For this consideration it is useful that you have a ring notebook and that you print the book only on the front of the pages: when a new song will be added you can print it and then you can add it to the printed book at the right place.
To avoid inconsistencies about adding a new song in a already printed book, there isn't the songs' number: you can add a song by alphabetical order.

## Getting started
This project is written in [LaTex](https://www.latex-project.org/) and use the [Songs package](http://songs.sourceforge.net/).

### Intall a Latex environment
[Get LaTex](https://www.latex-project.org/get/)

### Install the Songs package
[Get Songs Package](http://songs.sourceforge.net/downloads.html)
[Documentation of Songs package](http://songs.sourceforge.net/songsdoc/songs.html)

## Add a new song
* Copy the songTemp.tex from the repo in the right subdirectory of GuitarHub/tex/, example:
```
cd ./GuitarHub
cp songTemp.tex tex/exampleDir/
```
* Rename the copy with the title name of the song you want to write (avoid special carachters and spaces), example:
```
mv tex/exampleDir/songTemp.tex tex/exampleDir/TitleSong.tex
```
* Write the music (see the [documentation of Songs package](http://songs.sourceforge.net/songsdoc/songs.html))
* Add the song in a chapter input file, example:
```
echo '\input{tex/exampleDir/TitleSong.tex}' >> tex/exampleChapter.tex
```
Warning: this command is an example, it isn't put the song by alphabetical order.
* Add the chapter in the book, example:
```
...
\documentclass[openright]{book}
...
\usepackage[chorded]{songs}
...
\newindex{exampleChapter}{exampleChapter}
...
\begin{document}
...
\showindex[2]{Example of a Chapter}{exampleChapter} % view index
...
% New chapter
% Start on a right page and the title is in a blank page
\checkodd
\vspace*{\stretch{3}}
\songchapter{Example of a Chapter}
\vspace*{\stretch{5}}
\newpage
% Songs of this chapter
\begin{songs}{exampleChapter}
	\input{tex/exampleChapter.tex}
\end{songs}
...
\end{document}
```
