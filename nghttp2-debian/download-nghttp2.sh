#!/bin/bash -x

. /build/config-nghttp2.sh

dpkg -l | grep "^ii"| awk ' {print $2} ' > /installed_before.txt

apt-get update -y
apt-get $minimal_apt_get_args install $NGHTTP2_DOWNLOAD_PACKAGES

# download
cd /build

if test -n "$SPDYLAY_VERSION"; then
    curl -SL https://github.com/tatsuhiro-t/spdylay/releases/download/v${SPDYLAY_VERSION}/spdylay-${SPDYLAY_VERSION}.tar.xz -o spdylay.tar.xz
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
