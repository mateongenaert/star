FROM ubuntu:20.04
MAINTAINER mongenae@its.jnj.com

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

ENV STAR_VERSION 2.7.8a

WORKDIR /home

RUN apt-get update && \
    apt-get upgrade -y 

RUN apt-get install -y --fix-missing zlibc zlib1g zlib1g-dev make gcc g++ wget

RUN apt-get update

RUN wget --no-check-certificate https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.tar.gz
RUN tar -xzf ${STAR_VERSION}.tar.gz

WORKDIR /home/STAR-${STAR_VERSION}/source
RUN make STAR


ENV PATH /home/STAR-${STAR_VERSION}/source:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

RUN echo "export PATH=$PATH" > /etc/environment
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/environment
