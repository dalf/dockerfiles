#!/bin/sh

set +e

# Install dependencies
NGHTTP2_RUNTIME_PACKAGES="libgcc libstdc++ jemalloc libev libxml2 jansson zlib ca-certificates"
NGHTTP2_BUILD_PACKAGES="git curl xz clang clang-dev llvm gcc g++ autoconf automake make libtool file binutils jemalloc-dev libev-dev libxml2-dev jansson-dev zlib-dev cmake go"

apk --no-cache -U add $NGHTTP2_RUNTIME_PACKAGES $NGHTTP2_BUILD_PACKAGES

# Clang
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# BoringSSL
cd /build
git clone https://boringssl.googlesource.com/boringssl
cd boringssl

mkdir build
cd build
export LIBEVENT_OPENSSL_LIBS="-I/build/boringssl/include"
export OPENSSL_CFLAGS="-I/build/boringssl/include"
export OPENSSL_LIBS="-lcrypto -lssl"  
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1 -DCMAKE_USER_MAKE_RULES_OVERRIDE=/build/ClangOverrides.txt ..
make -j $(getconf _NPROCESSORS_ONLN)
cp /build/boringssl/build/ssl/libssl* /usr/lib
cp /build/boringssl/build/crypto/libcrypto* /usr/lib

# spdylay
if test "$SPDYLAY_VERSION" != "DISABLED"; then

  cd /build
  
  if test -n "$SPDYLAY_VERSION"; then
    curl -fSL https://github.com/tatsuhiro-t/spdylay/releases/download/v${SPDYLAY_VERSION}/spdylay-${SPDYLAY_VERSION}.tar.xz -o spdylay.tar.xz
    ls -l spdylay.tar.xz
    tar xJf spdylay.tar.xz
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
  ls -l nghttp2.tar.xz
  tar xJf nghttp2.tar.xz
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
