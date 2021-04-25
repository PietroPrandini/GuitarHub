#!/bin/bash

# Copyright 2018-2021 Pietro Prandini
#
# This file is part of GuitarHub.
#
# GuitarHub is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GuitarHub is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GuitarHub.  If not, see <https://www.gnu.org/licenses/>.

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
