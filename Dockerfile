#
# Dockerfile for shadowsocks-libev
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

ADD conf/* /conf/
ADD exec/* /exec/

RUN set -ex \
 # Build environment setup
 && apk update \
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
      git \
      gettext-dev \
      gnutls-dev \
      nettle-dev \
      gmp-dev \
      libssh2-dev \
      libxml2-dev \
      zlib-dev \
      sqlite-dev \
      pkgconfig \
      binutils \
 # Build & install
 && gcc --version \
 && git clone https://github.com/aria2/aria2.git /tmp/repo/aria2 \
 && cd /tmp/repo/aria2 \
 && autoreconf -i \
 && ./configure \
 && make -j8 \
 && cd src \
 && strip aria2c \
 && ls -lh aria2c \
 && install aria2c /usr/bin \
 && cd / \
 && apk del .build-deps \
 && rm -rf /tmp/repo \
 # Runtime dependencies setup
 && apk add --no-cache \
      rng-tools \
      $(scanelf --needed --nobanner /usr/bin/aria2c \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && aria2c -v \
 && chmod +x /exec/*.sh \
 && touch /conf/aria2.session

ENTRYPOINT ["/exec/entrypoint.sh"]

