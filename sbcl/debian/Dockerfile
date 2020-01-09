FROM fukamachi/roswell:19.12.13.103

ARG VERSION

RUN set -x; \
  ros install "sbcl-bin/${VERSION}" \
    && ros use "sbcl-bin/${VERSION}" \
    && rm /root/.roswell/archives/* \
      /root/.roswell/lisp/quicklisp/dists/quicklisp/archives/*

RUN set -x; \
  printf '#!/bin/sh\nros run -- "$@"\n' > /usr/local/bin/sbcl \
  && chmod u+x /usr/local/bin/sbcl

CMD ["ros", "run"]
