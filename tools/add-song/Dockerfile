FROM debian:bookworm
LABEL maintainer="Pietro Prandini" \
      description="A docker image based on Debian that provides adding song helper." \
      repo="https://github.com/PietroPrandini/GuitarHub"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt -y install python3 python3-unidecode
RUN mkdir /GuitarHub
WORKDIR /GuitarHub
ENTRYPOINT ["./tools/add-song/add-song.py"]

