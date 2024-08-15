# Docker images for ccl

[![Docker Pulls](https://img.shields.io/docker/pulls/fukamachi/ccl.svg)](https://hub.docker.com/r/fukamachi/ccl/)
[![Docker Stars](https://img.shields.io/docker/stars/fukamachi/ccl.svg)](https://hub.docker.com/r/fukamachi/ccl/)

## Usage

```
$ docker pull fukamachi/ccl
$ docker run -it --rm fukamachi/ccl
$ docker pull fukamachi/ccl:1.12.2
$ docker run -it --rm fukamachi/ccl:1.12.2
```

## Supported tags

- `1.13`, `1.13-debian`, `latest`, `latest-debian`
- `1.13-ubuntu`, `latest-ubuntu`
- `1.13-alpine`, `latest-alpine`
- `1.12.2`, `1.12.2-debian`
- `1.12.2-alpine`
- `1.12.2-ubuntu`
- `1.12.1`, `1.12.1-debian`
- `1.12.1-alpine`
- `1.12.1-ubuntu`
- `1.12`, `1.12-debian`
- `1.12-alpine`
- `1.12-ubuntu`
- `1.11.5`, `1.11.5-debian`
- `1.11.5-alpine`
- `1.11.5-ubuntu`
- `1.11`, `1.11-debian`
- `1.11-alpine`
- `1.11-ubuntu`
- `1.10`, `1.10-debian`
- `1.10-alpine`
- `1.10-ubuntu`

## Building by your own

```
$ docker build -t ccl:1.12.2 --build-arg VERSION=1.12.2 ccl/debian/
```
