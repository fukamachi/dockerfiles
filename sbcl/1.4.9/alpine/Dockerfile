FROM fukamachi/roswell:19.12.13.103-alpine

ENV SBCL_VERSION 1.4.9

RUN set -x; ros install "sbcl-bin/${SBCL_VERSION}"
RUN set -x; ros use "sbcl-bin/${SBCL_VERSION}"

RUN set -x; \
  echo '#!/bin/sh\nros run -- "$@"\n' > /usr/local/bin/sbcl \
  && chmod u+x /usr/local/bin/sbcl

CMD ["ros", "run"]
