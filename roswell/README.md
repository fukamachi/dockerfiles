# Docker images for roswell

[![Docker Pulls](https://img.shields.io/docker/pulls/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)
[![Docker Stars](https://img.shields.io/docker/stars/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)

## Usage

```
$ docker pull fukamachi/roswell
$ docker run -it --rm fukamachi/roswell
$ docker pull fukamachi/roswell:22.12.14.112
$ docker run -it --rm fukamachi/roswell:22.12.14.112
```

## Supported tags

- `22.12.14.113`, `22.12.14.113-debian`, `latest`, `latest-debian`
- `22.12.14.113-ubuntu`, `latest-ubuntu`
- `22.12.14.113-alpine`, `latest-alpine`
- `22.12.14.112`, `22.12.14.112-debian`
- `22.12.14.112-alpine`
- `22.12.14.112-ubuntu`
- `21.10.14.111`, `21.10.14.111-debian`
- `21.10.14.111-alpine`
- `21.10.14.111-ubuntu`
- `21.06.14.110`, `21.06.14.110-debian`
- `21.06.14.110-alpine`
- `21.06.14.110-ubuntu`
- `21.05.14.109`, `21.05.14.109-debian`
- `21.05.14.109-alpine`
- `21.05.14.109-ubuntu`
- `21.01.14.108`, `21.01.14.108-debian`
- `21.01.14.108-alpine`
- `21.01.14.108-ubuntu`
- `20.06.14.107`, `20.06.14.107-debian`
- `20.06.14.107-alpine`
- `20.06.14.107-ubuntu`
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

## Building by your own

```
$ docker build -t roswell:22.12.14.112 --build-arg VERSION=22.12.14.112 roswell/debian/
```
