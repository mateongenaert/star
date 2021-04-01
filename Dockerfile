FROM ubuntu:20.04
MAINTAINER mongenae@its.jnj.com

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

ENV STAR_VERSION 2.7.8a
ENV SAMTOOLS_VERSION 1.12

WORKDIR /home

RUN apt-get update && \
    apt-get upgrade -y 

RUN apt-get install -y --fix-missing zlibc zlib1g zlib1g-dev make gcc g++ wget libncurses5-dev libncursesw5-dev libbz2-dev liblzma-dev

RUN apt-get update

RUN wget --no-check-certificate https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.tar.gz
RUN tar -xzf ${STAR_VERSION}.tar.gz

WORKDIR /home/STAR-${STAR_VERSION}/source
RUN make STAR


ENV PATH /home/STAR-${STAR_VERSION}/source:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

WORKDIR /home
RUN wget --no-check-certificate https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
RUN tar -xvjf samtools-${SAMTOOLS_VERSION}.tar.bz2

WORKDIR /home/samtools-${SAMTOOLS_VERSION}
RUN ./configure --prefix=/home/samtools-${SAMTOOLS_VERSION}
RUN make
RUN make install

ENV PATH /home/samtools-${SAMTOOLS_VERSION}:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

RUN echo "export PATH=$PATH" > /etc/environment
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/environment
