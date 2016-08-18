nghttp2 docker image
====================

This *unofficial* Docker image of [nghttp2](https://github.com/nghttp2/nghttp2) 

* based on Alpine.
* Python is included for OCSP.
* OpenSSL 1.0.2h which support ALPN.
* nghttp2 is compiled with neverbleed option.
* [SPDY](https://github.com/tatsuhiro-t/spdylay/) support is disabled because it creates runtime problem.

You may be interested in [nghttp2-alpine](https://github.com/rlei/nghttp2-alpine).
