# Docker images for ccl

## Usage

```
$ docker pull fukamachi/ccl
$ docker run -it --rm fukamachi/ccl
$ docker pull fukamachi/ccl:1.11
$ docker run -it --rm fukamachi/ccl:1.11
```

## Supported tags

- `1.11.5`, `1.11.5-debian`, `latest`, `latest-debian`
- `1.11.5-ubuntu`, `latest-ubuntu`
- `1.11.5-alpine`, `latest-alpine`
- `1.11`, `1.11-debian`
- `1.11-alpine`
- `1.11-ubuntu`
- `1.10`, `1.10-debian`
- `1.10-alpine`
- `1.10-ubuntu`
- `1.9`, `1.9-debian`
- `1.9-alpine`
- `1.9-ubuntu`
- `1.8`, `1.8-debian`
- `1.8-alpine`
- `1.8-ubuntu`
- `1.7`, `1.7-debian`
- `1.7-alpine`
- `1.7-ubuntu`
- `1.6`, `1.6-debian`
- `1.6-alpine`
- `1.6-ubuntu`
- `1.5`, `1.5-debian`
- `1.5-alpine`
- `1.5-ubuntu`
- `1.4`, `1.4-debian`
- `1.4-alpine`
- `1.4-ubuntu`
- `1.3`, `1.3-debian`
- `1.3-alpine`
- `1.3-ubuntu`
- `1.2`, `1.2-debian`
- `1.2-alpine`
- `1.2-ubuntu`

## Building by your own

```
$ docker build -t ccl:1.11 --build-arg VERSION=1.11 sbcl/debian/
```
