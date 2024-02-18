# GuitarHub Generator

Docker image for GuitarHub books generation.

## Build

```
cd /path/to/GuitarHub/tools/guitarhub-generator
docker build -t guitarhub-generator .
```

## Execute

Generate the books.

```
docker run -it --rm -v /path/to/GuitarHub:/GuitarHub -t guitarhub-generator
```

