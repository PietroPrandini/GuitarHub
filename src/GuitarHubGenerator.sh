#!/bin/bash

INDEXLUAPATH=/opt/songs/share/songs/
PDFPATH=../
#PDFTOPRINTPATH=${PDFPATH}/ToPrint/

isSuccess() {
	exit_code=$1
	if [ "${exit_code}" -eq "0" ];
	then
		echo "OK!"
	else
		echo "KO! Exit code: ${exit_code}"
		exit
	fi
}

echo '
--> Generating the booklets <--'
#arara GuitarHub.tex

for booklet in $(ls | grep GuitarHub | grep tex | grep -v ToPrint)
do
	echo "--> Compiling ${booklet}"
	pdflatex ${booklet}
	isSuccess $?
	for index in $(ls | grep .sxd)
	do
		echo "--> Generating ${index} index"
		texlua ${INDEXLUAPATH}songidx.lua ${index} $(echo ${index} | sed s/sxd/sbx)
		isSuccess $?
	done
	pdflatex ${booklet}
	isSuccess $?
done

for pdf in $(ls | grep GuitarHub | grep pdf)
do
	echo "--> Moving ${pdf}"
	mv ${pdf} ${PDFPATH}
	isSuccess $?
done

echo '
--> pdf generated is moved to the main directory of GuitarHub
'
