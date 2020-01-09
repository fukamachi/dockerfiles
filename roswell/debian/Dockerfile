FROM debian:buster-slim

ARG VERSION

ADD https://github.com/roswell/roswell/releases/download/v${VERSION}/roswell_${VERSION}-1_amd64.deb roswell.deb

RUN set -x; \
  apt-get update && apt-get -y install --no-install-recommends \
    libcurl3-gnutls=7.64.0-4 \
    bzip2=1.0.6-9.2~deb10u1 \
    ca-certificates=20190110 \
    make=4.2.1-1.2 && \
  rm -rf /var/lib/apt/lists/* && \
  dpkg -i roswell.deb && rm roswell.deb

ENV PATH /root/.roswell/bin:${PATH}

CMD ["ros", "run"]
