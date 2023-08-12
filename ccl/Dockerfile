ARG ROSWELL_IMAGE=fukamachi/roswell
ARG ROSWELL_VERSION
ARG OS=debian

FROM fukamachi/roswell:latest-$OS AS build-env

ARG OS
ARG VERSION

ADD https://github.com/roswell/ccl_bin/releases/download/$VERSION/ccl-$VERSION-linuxx86.tar.gz ccl.tar.gz

# hadolint ignore=SC2010,DL3003,DL3008,DL4006
RUN set -x; \
  if [ "$OS" = "alpine" ]; then \
    ros install ccl-bin; \
  else \
    apt-get update && apt-get -y install --no-install-recommends build-essential m4; \
    ros install sbcl-bin && \
    tar xvfz ccl.tar.gz && rm ccl.tar.gz && \
      mkdir /root/.roswell/impls/x86-64/linux/ccl-bin && mv ccl "/root/.roswell/impls/x86-64/linux/ccl-bin/$VERSION"; \
    (cd "/root/.roswell/impls/x86-64/linux/ccl-bin/$VERSION/lisp-kernel/linuxx8664" || exit 1) && make && (cd /root || exit 1); \
  fi; \
  ls "/root/.roswell/impls/x86-64/linux/ccl-bin/$VERSION" | grep -v -E "lx86cl64|lx86cl64.image" | xargs rm -rf && \
    rm -rf /root/.roswell/impls/log

FROM $ROSWELL_IMAGE:$ROSWELL_VERSION-$OS

ARG BUILD_DATE
ARG VCS_REF
ARG OS
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fukamachi/dockerfiles" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

# hadolint ignore=DL3010
COPY --from=build-env /root/.roswell/impls /root/.roswell/impls

RUN set -x; \
  printf "setup.time\t0\t%s\n" "$(( $(date +%s) + 2208988800 ))" > ~/.roswell/config && \
  printf "sbcl-bin.version\t0\t%s\n" "$(ls /root/.roswell/impls/x86-64/linux/sbcl-bin)" >> ~/.roswell/config && \
  printf "ccl-bin.version\t0\t%s\n" "$VERSION" >> ~/.roswell/config && \
  printf "default.lisp\t0\tccl-bin\n" >> ~/.roswell/config && \
  ros setup && \
  ros -e '(mapc (function ql-dist:uninstall) (ql-dist:installed-releases t))' \
    && rm -f /root/.roswell/lisp/quicklisp/tmp/quicklisp.tar \
    && rm -rf /root/.roswell/archives/* /root/.roswell/src/sbcl-* /root/.cache/common-lisp/sbcl-*/root/.roswell/lisp/quicklisp/dists/quicklisp/software

RUN set -x; \
  printf '#!/bin/sh\nexec ros run -- "$@"\n' > /usr/local/bin/ccl \
  && chmod u+x /usr/local/bin/ccl

ENTRYPOINT ["/usr/local/bin/ccl"]
