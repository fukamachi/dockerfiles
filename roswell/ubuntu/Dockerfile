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

ADD https://github.com/roswell/roswell/archive/v${VERSION}.tar.gz roswell.tar.gz

# hadolint ignore=DL3008,DL3003
RUN set -x; \
  apt-get update && apt-get -y install --no-install-recommends \
    "${LIBCURL}" \
    ca-certificates \
    build-essential \
    automake && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  tar xvfz roswell.tar.gz && rm roswell.tar.gz && cd "roswell-${VERSION}" && \
  sh bootstrap && ./configure && make && make install \
    && cd .. && rm -rf "roswell-${VERSION}"

ENTRYPOINT ["ros"]
CMD ["run"]
