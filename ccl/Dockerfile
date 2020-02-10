ARG ROSWELL_IMAGE=fukamachi/roswell
ARG ROSWELL_VERSION
ARG PLATFORM=debian
FROM $ROSWELL_IMAGE:$ROSWELL_VERSION-$PLATFORM

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fukamachi/dockerfiles" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

RUN set -x; \
  ros install sbcl-bin && \
  ros install "ccl-bin/${VERSION}" \
    && ros use "ccl-bin/${VERSION}" \
    # Uninstall unnecessary files
    && ros -e '(ql:uninstall-dist "quicklisp")' -e '(ql-dist:install-dist "http://beta.quicklisp.org/dist/quicklisp.txt" :prompt nil)' \
    && rm -rf /root/.roswell/archives/* \
      /root/.roswell/src/sbcl-* \
      /root/.roswell/src/ccl-*

RUN set -x; \
  printf '#!/bin/sh\nros run -- "$@"\n' > /usr/local/bin/ccl \
  && chmod u+x /usr/local/bin/ccl

ENTRYPOINT ["/usr/local/bin/ccl"]
