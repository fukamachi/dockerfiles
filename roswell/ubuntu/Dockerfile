ARG BASE_IMAGE
# hadolint ignore=DL3006
FROM $BASE_IMAGE

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fukamachi/dockerfiles" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
ARG LIBCURL=libcurl4-gnutls-dev
ENV LANG C.UTF-8
ENV PATH /root/.roswell/bin:${PATH}

# hadolint ignore=DL3008,DL3003
RUN set -x; \
  apt-get update && apt-get -y install --no-install-recommends \
    curl \
    "${LIBCURL}" \
    bzip2 \
    ca-certificates \
    make \
    build-essential \
    automake && \
  curl -sL "https://github.com/roswell/roswell/archive/v${VERSION}.tar.gz" -o roswell.tar.gz && \
  tar xvfz roswell.tar.gz && cd "roswell-${VERSION}" && \
  sh bootstrap && ./configure && make && make install \
    && cd .. && rm roswell.tar.gz && rm -rf "roswell-${VERSION}" && \
  apt-get autoremove --purge -y curl build-essential automake && apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["ros"]
CMD ["run"]
