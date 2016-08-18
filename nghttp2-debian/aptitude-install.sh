#!/bin/bash -x

. /build/config-nghttp2.sh

apt-get install $minimal_apt_get_args $NGHTTP2_BUILD_PACKAGES
