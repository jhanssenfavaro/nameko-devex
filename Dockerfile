# FROM python:3.7-slim-stretch as base
FROM python:3.9 as base

#FIRST FIX
# RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --yes curl netcat

RUN pip3 install --upgrade pip
RUN pip3 install virtualenv

RUN virtualenv -p python3 /appenv

ENV PATH=/appenv/bin:$PATH

RUN groupadd -r nameko && useradd -r -g nameko nameko

RUN mkdir /var/nameko/ && chown -R nameko:nameko /var/nameko/

# ------------------------------------------------------------------------

FROM nameko-example-base as builder

RUN apt-get update && \
    apt-get install --yes build-essential autoconf libtool pkg-config \
    libgflags-dev libgtest-dev clang libc++-dev automake git libpq-dev

RUN pip install auditwheel

COPY . /application

ENV PIP_WHEEL_DIR=/application/wheelhouse
ENV PIP_FIND_LINKS=/application/wheelhouse
