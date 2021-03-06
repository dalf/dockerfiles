#!/bin/bash -x

. /build/config.sh

dpkg -l | grep "^ii"| awk ' {print $2} ' > /build/installed_before.txt

apt-get update -y
apt-get $minimal_apt_get_args install $NGHTTP2_DOWNLOAD_PACKAGES

# download nghttp2
cd /build

if test -n "$NGHTTP2_VERSION"; then
  curl -SL https://github.com/nghttp2/nghttp2/releases/download/v${NGHTTP2_VERSION}/nghttp2-${NGHTTP2_VERSION}.tar.xz -o nghttp2.tar.xz
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

# aptitude install
apt-get $minimal_apt_get_args install $NGHTTP2_BUILD_PACKAGES

# compile and install nghttp2
cd /build/nghttp2

autoreconf -i
automake
autoconf

./configure --enable-app --with-neverbleed\
            --disable-dependency-tracking\
            --disable-examples\
            --disable-debug\
	    --prefix=/usr

make install-strip -j${MAKE_J}

# Keep only initial packages
dpkg -l | grep "^ii"| awk ' {print $2} ' > /build/installed_after.txt
apt-get -y --auto-remove purge `diff /build/installed_before.txt /build/installed_after.txt  | grep "^>" | awk ' {print $2} ' | grep -v 'gcc-4.9-base:amd64'`

# Install the run-time dependencies
apt-get install $minimal_apt_get_args $NGHTTP2_RUN_PACKAGES

# Clean up
rm -rf /tmp/* /var/tmp/*

apt-get clean

rm -rf /var/lib/apt/lists/*

rm /var/log/dpkg.log

rm -rf /build
