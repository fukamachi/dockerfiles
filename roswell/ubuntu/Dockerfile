FROM ubuntu:18.04

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fukamachi/dockerfiles" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

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
