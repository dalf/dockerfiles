FROM alpine:3.5

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.23.1
ENV SPDYLAY_VERSION 1.4.0
ENV LIBRESSL_VERSION 2.5.4
ENV GPG_KEYS \
  B0F4253373F8F6F510D42178520A9993A1C052F8 \
  A1EB079B8D3EB92B4EBD3139663AF51BD5E4D8D5

ENV NGHTTP2_RUNTIME_PACKAGES "libgcc libstdc++ libev libxml2 jansson zlib python ca-certificates c-ares"
ENV NGHTTP2_BUILD_PACKAGES "linux-headers git curl xz gnupg gcc g++ autoconf automake make libtool file binutils libev-dev libxml2-dev jansson-dev zlib-dev c-ares-dev"

COPY build.sh /build/ 

RUN apk --no-cache -U add $NGHTTP2_RUNTIME_PACKAGES $NGHTTP2_BUILD_PACKAGES \
    && /build/build.sh \
    && apk del $NGHTTP2_BUILD_PACKAGES

