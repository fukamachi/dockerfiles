ARG ROSWELL_IMAGE=fukamachi/roswell
ARG ROSWELL_VERSION
ARG OS=debian
FROM fukamachi/roswell:latest-$OS AS build-env

ARG VERSION

ADD https://github.com/sbcl/sbcl/archive/sbcl-$VERSION.tar.gz sbcl.tar.gz

# hadolint ignore=DL3003,DL3008
RUN set -x; \
  arch="$(case $(uname -m) in amd64|x86_64) echo x86-64;; aarch64) echo arm64;; *) uname -m ;; esac)"; \
  if [ "$arch" = "x86-64" ]; then \
    ros install "sbcl-bin/${VERSION}"; \
  else \
    apt-get update && apt-get -y install --no-install-recommends \
      build-essential \
      zlib1g-dev \
      time && \
    ros setup && \
    tar xvfz sbcl.tar.gz && rm sbcl.tar.gz && cd "sbcl-sbcl-${VERSION}" && \
    echo "\"$VERSION\"" > version.lisp-expr && \
    (sh make.sh \
        --with-sb-core-compression \
        "--xc-host=ros -L sbcl-bin without-roswell=t --no-rc run" \
        "--prefix=$HOME/.roswell/impls/$arch/linux/sbcl-bin/$VERSION/" || true) \
      && sh install.sh; \
  fi; \
  tar -czvf /tmp/sbcl.tar.gz "$HOME/.roswell/impls/$arch/linux/sbcl-bin/$VERSION/"

FROM $ROSWELL_IMAGE:$ROSWELL_VERSION-$OS
# hadolint ignore=DL3010
COPY --from=build-env /tmp/sbcl.tar.gz /tmp/sbcl.tar.gz

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fukamachi/dockerfiles" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

RUN set -x; \
  tar xvfz /tmp/sbcl.tar.gz && rm /tmp/sbcl.tar.gz

RUN set -x; \
  printf "setup.time\t0\t%s\n" "$(( $(date +%s) + 2208988800 ))" > ~/.roswell/config && \
  printf "sbcl-bin.version\t0\t%s\n" "$VERSION" >> ~/.roswell/config && \
  printf "default.lisp\t0\tsbcl-bin\n" >> ~/.roswell/config && \
  ros setup \
    && ros -e '(ql:uninstall-dist "quicklisp")' -e '(ql-dist:install-dist "http://beta.quicklisp.org/dist/quicklisp.txt" :prompt nil)' \
    && rm -f /root/.roswell/lisp/quicklisp/tmp/quicklisp.tar \
    && rm -rf /root/.roswell/archives/* /root/.roswell/src/sbcl-* /root/.cache/common-lisp/sbcl-*/root/.roswell/lisp/quicklisp/dists/quicklisp/software

RUN set -x; \
  printf '#!/bin/sh\nexec ros run -- "$@"\n' > /usr/local/bin/sbcl \
  && chmod u+x /usr/local/bin/sbcl

CMD ["/usr/local/bin/sbcl"]
