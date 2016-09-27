FROM alpine:3.4

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.15.0
ENV SPDYLAY_VERSION 1.3.2

COPY *.sh /build/ 

RUN /build/build.sh
