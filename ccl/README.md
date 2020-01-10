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

## Building by your own

```
$ docker build -t ccl:1.11 --build-arg VERSION=1.11 sbcl/debian/
```
