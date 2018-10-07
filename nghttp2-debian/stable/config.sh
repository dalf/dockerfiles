# This file intended to be sourced
# . /build/config.sh

minimal_apt_get_args='-y --no-install-recommends'

# Prevent initramfs updates from trying to run grub and lilo.
export INITRD=no
export DEBIAN_FRONTEND=noninteractive

## Download time dependencies
# git and ca-certificates are needed for git clone; not building
# alternate would be to download a release tarball with curl or wget
# xz-utils is needed for tar to uncompress an .xz tarball
NGHTTP2_DOWNLOAD_PACKAGES="git ca-certificates curl xz-utils"

## Build time dependencies ##
# Core list from docs
# Optional:
#   libcunit1-dev - for tests
#   libjansson-dev - for HPACK tools
#   libjemalloc-dev - optional but recommended
#   cython python-dev - python bindings
NGHTTP2_BUILD_PACKAGES="$NGHTTP2_DOWNLOAD_PACKAGES g++ make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libssl-dev libxml2-dev libev-dev libevent-dev libjemalloc-dev libjansson-dev libc-ares-dev python-dev cython"

## Run time dependencies ##
# openssl binary is needed for OCSP /usr/share/nghttp2/fetch-ocsp-response
NGHTTP2_RUN_PACKAGES="libev4 libevent-2.0-5 libevent-openssl-2.0-5 libjemalloc1 libxml2 libjansson4 zlib1g openssl xml-core ca-certificates python libc-ares2"

#
if [[ -z ${MAKE_J} ]]; then
    MAKE_J=$(grep -c ^processor /proc/cpuinfo)
fi
