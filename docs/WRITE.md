# For writers
This project is a community project: you are welcome to actively contribute on it.

## Tools to install for generating the booklets
The GuitarHub booklets are written in [LaTex](https://www.latex-project.org/) with the use of the [Songs Package](http://songs.sourceforge.net/) and auto-generated by a python script.

### Installing the LaTex environment

#### Windows
* [Install Miktek](https://miktex.org/download)

#### GUN/Linux
* Debian/Ubuntu: Install "texlive-full" from the software manager or by terminal:``sudo apt install texlive-full``
* Fedora: Install "texlive-scheme-full" from the software manager or by terminal:``sudo dnf install texlive-scheme-full``
* Arch Linux: Install "texlive-most" and "texlive-lang" from the software manager or by terminal:``sudo pacman -S texlive-most texlive-lang``

#### Other systems
* [General guide to installing the environment on any operating system.](https://www.latex-project.org/get/)

### Installing python
* [Install python](https://www.python.org/downloads/)

### Installing a text editor (or an IDE specific for LaTex documents)
Some examples:
* [Atom](https://atom.io/) (recommended)
* [Texmaker](http://www.xm1math.net/texmaker/)

The choice is up to your personal preferences.

## Generating the booklets
_In order to generate the booklets correctly you need to install the tools indicated in the previous section._
### Using the GuitarHubGenerator (recommended)
#### On Windows
Double clik on the [GuitarHubGenerator](GuitarHubGenerator.py) file.  

#### On GNU/Linux
Open a terminal and execute the next commands.
```
cd "/path/to/GuitarHub/"
chmod +x ./tools/guitarhub-generator/guitarhub-generator.py #(you may need to do this only for the first time)
./tools/guitarhub-generator/guitarhub-generator.py
```

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
\songchapter{New Chapter}
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
$ cp tex/templates/SongBox.tex tex/chapters/chapterName/
$ cp tex/templates/SongBody.tex tex/songs/
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
