ARG ROSWELL_IMAGE=fukamachi/roswell
ARG ROSWELL_VERSION
ARG OS=debian
FROM fukamachi/roswell:latest-$OS AS build-env

ARG OS
ARG VERSION

ADD https://github.com/sbcl/sbcl/archive/sbcl-$VERSION.tar.gz sbcl.tar.gz

# hadolint ignore=DL3003,DL3008,DL3018,DL3019,DL4006
RUN set -x; \
  arch="$(case $(uname -m) in amd64|x86_64) echo x86-64;; aarch64) echo arm64;; *) uname -m ;; esac)"; \
  if [ "$OS" = "alpine" ]; then \
    apk add --update build-base linux-headers zstd-dev; \
  else \
    apt-get update && apt-get -y install --no-install-recommends \
      build-essential \
      zlib1g-dev \
      libzstd-dev \
      time; \
  fi; \
  ros setup && \
  tar xvfz sbcl.tar.gz && rm sbcl.tar.gz && cd "sbcl-sbcl-${VERSION}" && \
  echo "\"$VERSION\"" > version.lisp-expr && \
  (sh make.sh \
      --with-sb-core-compression \
      "--xc-host=ros -L sbcl-bin without-roswell=t --no-rc run" \
      "--prefix=$HOME/.roswell/impls/$arch/linux/sbcl-bin/$VERSION/" || true) \
    && sh install.sh && \
    rm -f "/root/.roswell/impls/$arch/linux/sbcl-bin/$VERSION/lib/sbcl/sbcl.core.old" \
      && rm -f "/root/.roswell/impls/$arch/linux/sbcl-bin/$VERSION/bin/sbcl.old" \
      && find "/root/.roswell/impls/$arch/linux/sbcl-bin" -maxdepth 1 -mindepth 1 | grep -v "/sbcl-bin/$VERSION$" | xargs rm -rf || true \
      && rm -rf "/root/.roswell/impls/log"

FROM $ROSWELL_IMAGE:$ROSWELL_VERSION-$OS
# hadolint ignore=DL3010
COPY --from=build-env /root/.roswell/impls /root/.roswell/impls

ARG BUILD_DATE
ARG VCS_REF
ARG OS
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fukamachi/dockerfiles" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

RUN set -x; \
  if [ "$OS" = "alpine" ]; then \
    apk add --update zstd-libs; \
  fi; \
  printf "setup.time\t0\t%s\n" "$(( $(date +%s) + 2208988800 ))" > ~/.roswell/config && \
  printf "sbcl-bin.version\t0\t%s\n" "$VERSION" >> ~/.roswell/config && \
  printf "default.lisp\t0\tsbcl-bin\n" >> ~/.roswell/config && \
  ros setup && \
  ros -e '(mapc (function ql-dist:uninstall) (ql-dist:installed-releases t))' \
    && rm -f /root/.roswell/lisp/quicklisp/tmp/quicklisp.tar \
    && rm -rf /root/.roswell/archives/* /root/.roswell/src/sbcl-* /root/.cache/common-lisp/sbcl-*/root/.roswell/lisp/quicklisp/dists/quicklisp/software

RUN set -x; \
  printf '#!/bin/sh\nexec ros run -- "$@"\n' > /usr/local/bin/sbcl \
  && chmod u+x /usr/local/bin/sbcl

ENTRYPOINT ["/usr/local/bin/sbcl"]
