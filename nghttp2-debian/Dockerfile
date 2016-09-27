FROM debian:8.5

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.15.0
ENV SPDYLAY_VERSION 1.3.2

COPY *.sh /build/ 

RUN /build/download-nghttp2.sh && \
    /build/aptitude-install.sh && \
    /build/build-nghttp2.sh && \
    /build/cleanup-nghttp2.sh
