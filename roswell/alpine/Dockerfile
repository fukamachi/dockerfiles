FROM frolvlad/alpine-glibc:alpine-3.10 AS build-env
ARG VERSION

ARG USER_NAME="fukamachi"
ARG USER_EMAIL="e.arrows@gmail.com"
ARG LOGIN_USER="roswell-builder"

RUN set -x; \
  apk add --no-cache \
    alpine-sdk=1.0-r0 \
    su-exec=0.2-r0 && \
  adduser -D $LOGIN_USER && \
  addgroup $LOGIN_USER abuild && \
  echo "$LOGIN_USER ALL=(ALL) ALL" >> /etc/sudoers && \
  mkdir -p /var/cache/distfiles && \
  chgrp abuild /var/cache/distfiles && \
  chmod g+w /var/cache/distfiles && \
  echo "PACKAGER='$USER_NAME <$USER_EMAIL>'" >> /etc/abuild.conf

RUN set -x; \
  su-exec $LOGIN_USER git config --global user.name $USER_NAME && \
  su-exec $LOGIN_USER git config --global user.email $USER_EMAIL

WORKDIR /roswell/
COPY APKBUILD .

RUN set -x; \
  su-exec $LOGIN_USER abuild-keygen -a && \
  sed -i -e 's/%%VERSION%%/'"$VERSION"'/g' APKBUILD

RUN set -x; \
  chmod -R a+w . && \
  su-exec $LOGIN_USER abuild checksum && \
  su-exec $LOGIN_USER abuild -r

FROM frolvlad/alpine-glibc:alpine-3.10
ARG VERSION
COPY --from=build-env /home/roswell-builder/packages/x86_64/roswell-$VERSION-r0.apk roswell.apk

# hadolint ignore=DL3018
RUN set -x; apk add --allow-untrusted --no-cache roswell.apk \
  && rm roswell.apk

ENV PATH /root/.roswell/bin:${PATH}

CMD ["ros", "run"]
