#!/usr/bin/env python3

# Copyright 2018-2022 Pietro Prandini
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
import os

root = os.path.dirname(os.path.abspath(__file__))
src = os.path.join(root, "src")
songidx = os.path.join(
    os.path.join(
        src, os.path.join(
            "tex", os.path.join(
                "utils", os.path.join(
                    "songs", "songidx"
                )
            )
        )
    ),
    "songidx.lua",
)
qrcode = os.path.join(os.path.join(src, "tex"), "qrcode")
tex_extension = ".tex"
update_extension = "Update.tex"
index_in_extension = ".sxd"
index_out_extesion = ".sbx"
pdf_extension = ".pdf"
py_extension = ".py"


def log(str):
    print(str)


def check(status):
    if status != 0:
        log("KO!")
        input("Press Enter to exit...")
        exit()
    else:
        log("OK!")



def pdflatex(tex):
    log("Producing a " + tex.replace(tex_extension, pdf_extension))
    status = os.system('pdflatex "' + os.path.join(src, tex) + '"')
    check(status)


def booklet(tex):
    log("Producing a " + tex.replace(tex_extension, "") + " draft and the index(es)")
    status = os.system('pdflatex "' + os.path.join(src, tex) + '"')
    check(status)
    for index in os.listdir(src):
        if index.endswith(index_in_extension):
            log("Producing " + index.replace(index_in_extension, "") + " index")
            status = os.system(
                'texlua "'
                + songidx
                + '" "'
                + os.path.join(src, index)
                + '" "'
                + os.path.join(
                    src, index.replace(index_in_extension, index_out_extesion)
                )
                + '"'
            )
            check(status)
    log("Finalizing " + tex.replace(tex_extension, ""))
    status = os.system('pdflatex "' + os.path.join(src, tex) + '"')
    check(status)


os.chdir(src)
log("Generating qrcodes")
for tex in os.listdir(qrcode):
    if tex.endswith(tex_extension):
        status = os.system('pdflatex "' + os.path.join(qrcode, tex) + '"')
        check(status)
        os.replace(
            os.path.join(src, tex.replace(tex_extension, pdf_extension)),
            os.path.join(
                os.path.join(root, "qrcode"), tex.replace(tex_extension, pdf_extension)
            ),
        )

log("Generating the booklets")
for tex in os.listdir(src):
    if tex.endswith(tex_extension) and not tex.endswith(update_extension):
        booklet(tex)

log("Moving the pdf in the " + root + "directory")
for pdf in os.listdir(src):
    if pdf.endswith(pdf_extension):
        log("Moving " + pdf)
        os.replace(os.path.join(src, pdf), os.path.join(root, pdf))

log("Generating the updates")
for tex in os.listdir(src):
    if tex.endswith(update_extension):
        pdflatex(tex)

log("Moving the pdf in the " + root + "directory")
for pdf in os.listdir(src):
    if pdf.endswith(pdf_extension):
        log("Moving " + pdf)
        os.replace(os.path.join(src, pdf), os.path.join(root, pdf))

log("Cleaning")
for trash in os.listdir(src):
    if not (
        trash.endswith(tex_extension)
        or trash.endswith(py_extension)
        or os.path.isdir(os.path.join(src, trash))
    ):
        log("Removing " + trash)
        os.remove(os.path.join(src, trash))
