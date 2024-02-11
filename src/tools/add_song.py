#!/usr/bin/env python3

# Copyright 2018-2024 Pietro Prandini
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
import shutil
import sys
import unidecode


if len(sys.argv) != 3:
    print("Use guide: add_song.py \"<title>\" \"<chapter>\"")
    exit(1)

title = sys.argv[1]
chapter = sys.argv[2]
src_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), os.pardir)
tex_dir = os.path.join(src_dir, "tex")
chapters_dir = os.path.join(tex_dir, "chapters")

if str(chapter) not in os.listdir(chapters_dir) or not os.path.isdir(os.path.join(chapters_dir, chapter)):
    print('Chapter \"' + chapter + '\" is not exist.')
    exit(1)

file_name = unidecode.unidecode(title)
chapter_dir = os.path.join(chapters_dir, chapter)
song_box = os.path.join(chapter_dir, file_name + ".tex")

songs_dir = os.path.join(tex_dir, "songs")
song_body = os.path.join(songs_dir, file_name + ".tex")

template_dir = os.path.join(tex_dir, "templates")
song_box_template = os.path.join(template_dir, "SongBox.tex")
song_body_template = os.path.join(template_dir, "SongBody.tex")


if not os.path.exists(song_body) and not os.path.exists(song_box):
    shutil.copyfile(song_body_template, song_body)
    
    box_template_file = open(song_box_template, 'r')
    box_file = open(song_box, 'w')

    title_label = "<title>"
    file_name_label = "<file_name>"

    box_lines = []
    for line in box_template_file.readlines():
        box_lines.append(line.replace(title_label, title).replace(file_name_label, file_name))
    box_file.writelines(box_lines)
    
    box_template_file.close()
    box_file.close()

    chapter_songs_list_file = os.path.join(chapters_dir, chapter + ".tex")

    new_song = "\input{\"tex/chapters/" + chapter + "/" + file_name + ".tex\"}\\newsongpage\n"

    songs_list = []
    with open(chapter_songs_list_file, 'r') as file:
        for song in file.readlines():
            songs_list.append(song)
        file.close()
    
    songs_list_compare = []
    for i in range(len(songs_list)):
        subtring_end = len(songs_list[i])
        
        if songs_list[i].find('%') > 0:
            subtring_end = songs_list[i].find('%')

        songs_list_compare.append(songs_list[i].lstrip()[:subtring_end])

    songs_list_updated = []
    song_added = False
    for i in range(len(songs_list_compare)):
        songs_list_updated.append(songs_list[i])

        j = i + 1
        if song_added:
            continue
        if j < len(songs_list) and (songs_list_compare[j].find("\\ifchorded") == 0 or songs_list_compare[j].find("\\fi") == 0):
            continue
        if j < len(songs_list) and songs_list_compare[j].lower() > new_song.lower() and not song_added:
            songs_list_updated.append(new_song)
            song_added = True
            continue
        if j == len(songs_list) and not song_added:
            songs_list_updated.append(new_song)
            break
    
    with open(chapter_songs_list_file, 'w') as file:
        file.writelines(songs_list_updated)
        file.close()
    




