#!/bin/bash -x

. /build/config-nghttp2.sh

cd /build

# compile spdylay
cd spdylay

autoreconf -i
automake
autoconf
./configure --disable-dependency-tracking\
            --disable-examples --disable-src --disable-static\
            --prefix=/usr

make install

cd ..

# compile nghttp2
cd nghttp2

if test ! -r "configure"; then
  autoreconf -i
  automake
  autoconf
fi

./configure --enable-app --with-neverbleed \
            --disable-dependency-tracking\
            --disable-examples --disable-static --disable-debug \
	    --prefix=/usr

make install

# strip
strip /usr/bin/nghttp /usr/bin/nghttpd /usr/bin/nghttpx /usr/bin/h2load /usr/bin/deflatehd
