FROM alpine:3.4

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.13.0
ENV SPDYLAY_VERSION DISABLED

COPY *.sh /build/ 

RUN /build/build.sh
