#!/bin/sh

set -e

# Install dependencies
apk --no-cache -U add $NGHTTP2_RUNTIME_PACKAGES $NGHTTP2_BUILD_PACKAGES

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
  git clone --depth 1 --single-branch https://github.com/nghttp2/nghttp2
fi

# Compile / Install nghttp2
cd /build/nghttp2

autoreconf -i
automake
autoconf

./configure --enable-app\
            --disable-dependency-tracking\
            --disable-examples  --disable-hpack-tools --disable-python-bindings\
	    --enable-static --disable-shared\
	    --prefix=/usr

make -j $(getconf _NPROCESSORS_ONLN)
make install-strip

# Remove build packages
apk del $NGHTTP2_BUILD_PACKAGES

# Remove /build
rm -rf /build
