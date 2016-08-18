#!/bin/sh -x

. /build/config-nghttp2.sh

# Keep only initial packages
dpkg -l | grep "^ii"| awk ' {print $2} ' > /installed_after.txt
apt-get -y --auto-remove purge `diff /installed_before.txt /installed_after.txt  | grep "^>" | awk ' {print $2} ' | grep -v 'gcc-4.9-base:amd64'`

# Install the run-time dependencies
apt-get install $minimal_apt_get_args $NGHTTP2_RUN_PACKAGES

# . /build/cleanup.sh
rm -rf /tmp/* /var/tmp/*

apt-get clean

rm -rf /var/lib/apt/lists/*

rm /var/log/dpkg.log

# Remove /build
rm -rf /build


