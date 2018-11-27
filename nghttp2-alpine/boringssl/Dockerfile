FROM alpine:3.8

MAINTAINER Alexandre Flament <alex@al-f.net>

ENV NGHTTP2_VERSION 1.35.0

ENV NGHTTP2_RUNTIME_PACKAGES "libgcc libstdc++ libev libxml2 jansson zlib ca-certificates c-ares"
ENV NGHTTP2_BUILD_PACKAGES "git curl xz gcc g++ autoconf automake make libtool file binutils libev-dev libxml2-dev jansson-dev zlib-dev cmake go c-ares-dev"

COPY build.sh /build/

RUN apk --no-cache -U add $NGHTTP2_RUNTIME_PACKAGES $NGHTTP2_BUILD_PACKAGES \
    && /build/build.sh \
    && apk del $NGHTTP2_BUILD_PACKAGES
