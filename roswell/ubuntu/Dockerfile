FROM ubuntu:18.04

ARG VERSION

ADD https://github.com/roswell/roswell/releases/download/v${VERSION}/roswell_${VERSION}-1_amd64.deb roswell.deb

RUN set -x; \
  apt-get update && apt-get -y install --no-install-recommends \
    libcurl3-gnutls=7.58.0-2ubuntu3.8 \
    ca-certificates=20180409 \
    make=4.1-9.1ubuntu1 && \
  rm -rf /var/lib/apt/lists/* && \
  dpkg -i roswell.deb && rm roswell.deb

ENV PATH /root/.roswell/bin:${PATH}

CMD ["ros", "run"]
