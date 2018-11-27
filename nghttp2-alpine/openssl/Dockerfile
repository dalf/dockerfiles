FROM alpine:3.8

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.35.0

ENV NGHTTP2_RUNTIME_PACKAGES="libgcc libstdc++ openssl jemalloc libev libxml2 jansson zlib python ca-certificates c-ares"
ENV NGHTTP2_BUILD_PACKAGES="linux-headers git curl xz gcc g++ autoconf automake make libtool file binutils openssl-dev jemalloc-dev libev-dev libxml2-dev jansson-dev zlib-dev c-ares-dev"

COPY *.sh /build/ 

RUN /build/build.sh
