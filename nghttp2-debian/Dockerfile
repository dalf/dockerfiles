FROM debian:8.7

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.21.0
ENV SPDYLAY_VERSION 1.4.0

COPY *.sh /build/ 

RUN /build/download-nghttp2.sh && \
    /build/aptitude-install.sh && \
    /build/build-nghttp2.sh && \
    /build/cleanup-nghttp2.sh
