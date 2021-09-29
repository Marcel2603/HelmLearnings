FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y\
   curl \
   git \
   bash \
   sudo \
   zsh \
   wget \
   locales \
   powerline \
   language-pack-en

RUN update-locale

RUN useradd -m m.herhold && echo "m.herhold:test" | chpasswd && adduser m.herhold sudo
WORKDIR /home/m.herhold

COPY files .

USER m.herhold

CMD /bin/bash
