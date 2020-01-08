FROM alpine:3.10

ENV ROSWELL_VERSION 19.09.12.102

WORKDIR /build

RUN set -x; \
  apk add --no-cache --virtual .fetch-deps curl && \
    curl -L "https://github.com/roswell/roswell/archive/v${ROSWELL_VERSION}.tar.gz" | tar zx -C ./ \
      && mv "roswell-${ROSWELL_VERSION}" roswell && \
    curl -L https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -L https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk -o glibc.apk \
      && apk add glibc.apk \
    && apk del --no-network .fetch-deps; \
  apk add --no-cache \
    gcc \
    zlib-dev \
    build-base \
    curl-dev \
    ca-certificates; \
  apk add --no-cache --virtual .build-deps autoconf automake make build-base \
    && cd ./roswell && sh bootstrap && ./configure && make && make install \
    && apk del --no-network .build-deps \
  && cd / && rm -rf /build

WORKDIR /

ENV LD_LIBRARY_PATH /lib
ENV PATH /root/.roswell/bin:${PATH}

CMD ["ros", "run"]
