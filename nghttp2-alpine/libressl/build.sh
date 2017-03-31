#!/bin/sh

set -e

# Install dependencies
NGHTTP2_RUNTIME_PACKAGES="libgcc libstdc++ jemalloc libev libxml2 jansson zlib python ca-certificates c-ares"
NGHTTP2_BUILD_PACKAGES="git curl xz gnupg gcc g++ autoconf automake make libtool file binutils jemalloc-dev libev-dev libxml2-dev jansson-dev zlib-dev linux-headers c-ares-dev"

apk --no-cache -U add $NGHTTP2_RUNTIME_PACKAGES $NGHTTP2_BUILD_PACKAGES

# LibreSSL
cd /build

for key in $GPG_KEYS; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key";
done

curl -fSL http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz -o libressl.tar.gz
curl -fSL http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-${LIBRESSL_VERSION}.tar.gz.asc -o libressl.tar.gz.asc
gpg --batch --verify libressl.tar.gz.asc libressl.tar.gz
tar -zxf libressl.tar.gz
cd libressl-${LIBRESSL_VERSION}

./configure --prefix=/usr
make -j $(getconf _NPROCESSORS_ONLN)
make install-strip

# spdylay
if test "$SPDYLAY_VERSION" != "DISABLED"; then

  cd /build
  
  if test -n "$SPDYLAY_VERSION"; then
    curl -fSL https://github.com/tatsuhiro-t/spdylay/releases/download/v${SPDYLAY_VERSION}/spdylay-${SPDYLAY_VERSION}.tar.xz -o spdylay.tar.xz
    if [ 0 -ne $? ]; then
	exit 1
    fi
    ls -l spdylay.tar.xz
    tar xJf spdylay.tar.xz
    if [ 0 -ne $? ]; then
	exit 1
    fi
    mv spdylay-${SPDYLAY_VERSION} spdylay
  else
    git clone https://github.com/tatsuhiro-t/spdylay.git
  fi

  cd /build/spdylay

  autoreconf -i
  automake
  autoconf
  ./configure --disable-dependency-tracking\
              --disable-examples --disable-src --disable-static\
              --prefix=/usr

  make -j $(getconf _NPROCESSORS_ONLN)
  make install
fi

# Download nghttp2
if test -n "$NGHTTP2_VERSION"; then

  cd /build
  
  curl -fSL https://github.com/nghttp2/nghttp2/releases/download/v${NGHTTP2_VERSION}/nghttp2-${NGHTTP2_VERSION}.tar.xz -o nghttp2.tar.xz
  if [ 0 -ne $? ]; then
      exit 1
  fi
  ls -l nghttp2.tar.xz
  tar xJf nghttp2.tar.xz
  if [ 0 -ne $? ]; then
      exit 1
  fi
  mv nghttp2-${NGHTTP2_VERSION} nghttp2
else
  git clone https://github.com/nghttp2/nghttp2
fi

# Compile / Install nghttp2
cd /build/nghttp2

autoreconf -i
automake
autoconf

./configure --enable-app\
            --disable-dependency-tracking\
            --disable-examples --disable-static\
	    --prefix=/usr

make -j $(getconf _NPROCESSORS_ONLN)
make install-strip

# Remove build packages
apk del $NGHTTP2_BUILD_PACKAGES

# Remove /build
rm -rf /build
