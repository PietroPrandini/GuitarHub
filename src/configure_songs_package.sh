#!/bin/bash

wget -c http://prdownloads.sourceforge.net/songs/songs-3.1.tar.gz?download -O songs.tar.gz
tar -xzf songs.tar.gz
cd songs
./configure
make

