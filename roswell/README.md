# Docker images for roswell

[![Docker Pulls](https://img.shields.io/docker/pulls/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)
[![Docker Stars](https://img.shields.io/docker/stars/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)

## Usage

```
$ docker pull fukamachi/roswell
$ docker run -it --rm fukamachi/roswell
$ docker pull fukamachi/roswell:19.09.12.102
$ docker run -it --rm fukamachi/roswell:19.09.12.102
```

## Supported tags

- `19.12.13.103`, `19.12.13.103-debian`, `latest`, `latest-debian`
- `19.12.13.103-ubuntu`, `latest-ubuntu`
- `19.12.13.103-alpine`, `latest-alpine`
- `19.09.12.102`, `19.09.12.102-debian`
- `19.09.12.102-alpine`
- `19.09.12.102-ubuntu`
- `19.08.10.101`, `19.08.10.101-debian`
- `19.08.10.101-alpine`
- `19.08.10.101-ubuntu`
- `19.06.10.100`, `19.06.10.100-debian`
- `19.06.10.100-alpine`
- `19.06.10.100-ubuntu`
- `19.05.10.99`, `19.05.10.99-debian`
- `19.05.10.99-alpine`
- `19.05.10.99-ubuntu`

## Building by your own

```
$ docker build -t roswell:19.09.12.102 --build-arg VERSION=19.09.12.102 roswell/debian/
```
