FROM alpine:3.5

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.21.0
ENV SPDYLAY_VERSION 1.4.0

COPY *.sh /build/ 

RUN /build/build.sh
