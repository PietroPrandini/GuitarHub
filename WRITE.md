# For writers
This project is a community project: you are welcome to participate in it.

## Tools
The GuitarHub booklets are written in [LaTex](https://www.latex-project.org/) with the use of the [Songs Package](http://songs.sourceforge.net/).

## The LaTex environment
[Guide to installing the environment](https://www.latex-project.org/get/)

## The Songs Package
[Guide to installing the Songs Package](http://songs.sourceforge.net/downloads.html)

## A text editor or an IDE specific for LaTex documents
A [text editor](https://en.wikipedia.org/wiki/Text_editor) or an IDE specific for LaTex documents are is useful in editing the songs and the code of this book.
There are many text editors ([Atom](https://atom.io/), [Vim](https://www.vim.org/), [Emacs](https://www.gnu.org/software/emacs/)) and many IDE for LaTex ([Texmaker](http://www.xm1math.net/texmaker/), [TeXstudio](https://sourceforge.net/projects/texstudio/), [TeXworks](https://www.tug.org/texworks/)).  
The choice is up to your personal preferences.

## Setting up a new chapter
*Note: if you would like to add a new song to an existing chapter you can skip this part.*
The booklet can contain a number of chapters. Each chapter has a main directory located in src/tex/ and an input .tex file, both named likewise. In order to create a new chapter, you need to create them first; the chapter directory contains the song files and the input .tex file contains the input statements to adds the song files to the booklets. Later you have to declare it in the src/GuitarHubPreamble.tex. Finally, you can add each song from the new chapter to the booklet located in src/tex/commons/GuitarHubBody.tex.
## Creating a new chapter, an example:
### *Creating* the chapter directory and the input .tex file:
Open a terminal and create them in /path/to/GuitarHub/src/tex/
```
$ cd /path/to/GuitarHub/src/tex/chapter
$ mkdir newChapter
$ touch newChapter.tex
```
### *Declaring* the chapter in the src/GuitarHubPreamble.tex:
Open src/tex/commons/GuitarHubPreamble.tex with a text editor and declare it
```
%...
%	Indexes
%...
\newindex{newChapter}{newChapter} %new chapter declared
%...
```
### *Adding* the song chapter to the booklet:
Open src/tex/commons/GuitarHubBody.tex with a text editor and add it
```
\begindocument
%...
%	Chapter first page
\vspace*{\stretch{3}}
\songchapter{New Chapter} % full name of the new chapter
\vspace*{\stretch{5}}
\vspace*{\fill}
\newpage

%	Songs of the chapter
\begin{songs}{newChapter} % name declared in src/tex/commons/GuitarHubPreamble.tex
	\input{tex/chapters/newChapter.tex} % input file .tex of the new chapter
\end{songs}
%...
```

## Adding a new song
Each song is connected to an existing chapter. If the chapter does not exist yet – you have to setup it up. In order to facilitate the process of creating a new song a template has been created: *SongBox.tex* and *SongBody.tex*. No special skills are required to create a song with these template. You can find them in the src/ directory and then copy them to the proper directories. Then you have to rename them, for example with the title of the new song. Now it is time for declaring it in the input .tex file of the chapter where you added this song. Finally, you can create the song itself.

## Creating a new song, an example:
### *Copying* the templates from src/ to the proper directories:
```
$ cd ./GuitarHub/src/
$ cp templates/SongBox.tex tex/chapters/chapterName/
$ cp templates/SongBody.tex tex/songs/
```
### *Renaming* the copy with the title of the new song
```
$ mv "tex/chapters/chapterName/TemplateSongBox.tex" "tex/chapters/chapterName/Title song.tex"
$ mv "tex/songs/TemplateSongBody.tex" "tex/songs/Title song.tex"
```
### *Adding* the song in the chapter input file
```
$ echo $'\input{"tex/chapters/chapterName/Title song.tex"}\sclearpage' >> tex/chapters/chapterName.tex
```
*Warning: this command is an example, it does not put the song in an alphabetical order.*

### *Start writing* the song
You can find some other songs in the [song project directory](https://github.com/PietroPrandini/GuitarHub/tree/master/src/tex/songs) and a [useful cheat sheet](https://github.com/PietroPrandini/GuitarHub/blob/master/CHEATSHEET.md) to support your writing experience.  

## Generating the booklets
As you add some songs to GuitarHub platform, you would be able to generate the booklets. With the script src/GuitarHubGenerator.sh you can generate every booklet easily, only with a usage of a command.   
Otherwise, if you prefer, you can generate them manually.
## Generating the booklets with GuitarHubGenerator.sh, an example:
```
$ cd /path/to/GuitarHub/src/
$ sh GuitarHubGenerator.sh
```
This command creates: the guitar chord booklet with songs in an alphabetical order, the guitar chord booklet with solfege note names and the lyrics booklet /path/to/GuitarHub/ .  
Note: this script works with a GNU/Linux environment.
## Generating the booklets manually, an example:
* Open a terminal and change the directory
```
$ cd /path/to/GuitarHub/src/
```
* Initial compiling (generate files for creating the indexes)
```
$ pdflatex GuitarHubAlphabeticNoteNames.tex
```
* Generate the indexes (repeat for each of the chapters)
```
$ texlua /usr/local/share/songs/songidx.lua "chapterName.sxd"
```
* Final compiling (add the generated indexes)
```
$ pdflatex GuitarHubAlphabeticNoteNames.tex
```
* Move the generated .pdf of the booklets to the root directory of the project
```
$ mv GuitarHubAlphabeticNoteNames.pdf ../GuitarHubAlphabeticNoteNames.pdf
```
*Note: repeat these points for each of the GuitarHub booklets.*  
