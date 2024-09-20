# Add song helper

An helper for adding songs.

## Build

```
cd /path/to/GuitarHub/tools/add-song
docker build -t add-song .
```

## Execute

Add the song.

```
docker run -it --rm -v /path/to/GuitarHub:/GuitarHub -t add-song "<title>" "<chapter>"
```

