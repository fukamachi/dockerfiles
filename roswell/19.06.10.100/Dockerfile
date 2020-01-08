FROM debian:buster-slim AS fetch-env

ENV ROSWELL_VERSION 19.06.10.100

RUN set -x; \
  apt-get update && apt-get -y install --no-install-recommends \
    curl \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN set -x; \
  curl -L "https://github.com/roswell/roswell/archive/v${ROSWELL_VERSION}.tar.gz" | tar zx -C /; \
  mv "/roswell-${ROSWELL_VERSION}" /roswell

FROM debian:buster-slim
COPY --from=fetch-env /roswell /roswell

RUN set -x; \
  apt-get update && apt-get -y install --no-install-recommends \
    build-essential \
    automake \
    libcurl4-openssl-dev \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN set -x; \
  cd /roswell && sh bootstrap && ./configure && make && make install \
  && cd / && rm -rf /roswell

ENV PATH /root/.roswell/bin:${PATH}

CMD ["ros", "run"]
