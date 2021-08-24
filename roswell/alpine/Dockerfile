ARG BASE_IMAGE
# hadolint ignore=DL3006
FROM $BASE_IMAGE AS build-env

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/fukamachi/dockerfiles" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ARG USER_NAME="fukamachi"
ARG USER_EMAIL="e.arrows@gmail.com"
ARG LOGIN_USER="roswell-builder"

# hadolint ignore=DL3018,DL3019
RUN set -x; \
  apk add --update \
    alpine-sdk \
    su-exec && \
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
  su-exec $LOGIN_USER abuild-keygen -a -n && \
  sed -i -e 's/%%VERSION%%/'"$VERSION"'/g' APKBUILD

RUN set -x; \
  chmod -R a+w . && \
  su-exec $LOGIN_USER abuild checksum && \
  su-exec $LOGIN_USER abuild -r

# hadolint ignore=DL3006
FROM $BASE_IMAGE
ARG VERSION
ENV LANG C.UTF-8
ENV PATH /root/.roswell/bin:${PATH}
COPY --from=build-env /home/roswell-builder/packages/x86_64/roswell-$VERSION-r0.apk roswell.apk

# hadolint ignore=DL3018
RUN set -x; apk add --allow-untrusted --no-cache roswell.apk \
  && rm roswell.apk

ENTRYPOINT ["ros"]
CMD ["run"]
