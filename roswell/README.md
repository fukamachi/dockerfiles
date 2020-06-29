# Docker images for roswell

[![Docker Pulls](https://img.shields.io/docker/pulls/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)
[![Docker Stars](https://img.shields.io/docker/stars/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)

## Usage

```
$ docker pull fukamachi/roswell
$ docker run -it --rm fukamachi/roswell
$ docker pull fukamachi/roswell:20.05.14.106
$ docker run -it --rm fukamachi/roswell:20.05.14.106
```

## Supported tags

- `20.06.14.107`, `20.06.14.107-debian`, `latest`, `latest-debian`
- `20.06.14.107-ubuntu`, `latest-ubuntu`
- `20.06.14.107-alpine`, `latest-alpine`
- `20.05.14.106`, `20.05.14.106-debian`
- `20.05.14.106-alpine`
- `20.05.14.106-ubuntu`
- `20.04.14.105`, `20.04.14.105-debian`
- `20.04.14.105-alpine`
- `20.04.14.105-ubuntu`
- `20.01.14.104`, `20.01.14.104-debian`
- `20.01.14.104-alpine`
- `20.01.14.104-ubuntu`
- `19.12.13.103`, `19.12.13.103-debian`
- `19.12.13.103-alpine`
- `19.12.13.103-ubuntu`
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
$ docker build -t roswell:20.05.14.106 --build-arg VERSION=20.05.14.106 roswell/debian/
```
