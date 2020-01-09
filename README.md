# Dockerfiles for Common Lisp programming

Dockerfiles for each version of Common Lisp implementations and utilities. Currently provides for the following products:

- [roswell](https://github.com/roswell/roswell), a Common Lisp implementation manager
  - [https://hub.docker.com/r/fukamachi/roswell](https://hub.docker.com/r/fukamachi/roswell)
- [sbcl](http://sbcl.org), a high-performance Common Lisp compiler
  - [https://hub.docker.com/r/fukamachi/sbcl](https://hub.docker.com/r/fukamachi/sbcl)

## Usage

### Building by yourself

```
$ git clone https://github.com/fukamachi/dockerfiles
$ cd dockerfiles

# Build SBCL 2.0.0 image (Debian)
$ docker build -t sbcl:2.0.0 ./sbcl/2.0.0
# On Alpine Linux
$ docker build -t sbcl:2.0.0-alpine ./sbcl/2.0.0/alpine

# Start a REPL
$ docker run -it --rm sbcl:2.0.0
* (lisp-implementation-type)
"SBCL"
* (lisp-implementation-version)
"2.0.0"
```

### Using built images

Build images are also available on Docker Hub.

```
$ docker pull fukamachi/sbcl:latest
$ docker run -it --rm fukamachi/sbcl:latest
* (lisp-implementation-type)
"SBCL"
* (lisp-implementation-version)
"2.0.0"
```

## Fork

To make GitHub Actions work, add your Docker Hub password as a secret named `DOCKER_HUB_PASSWORD` to your forked GitHub repository. See [GitHub's document](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets).

## Developer notes

These scripts will be called by [GitHub Actions](https://github.com/fukamachi/dockerfiles/actions) automatically, however, sometimes it needs to be run manually.

### Generate Dockerfiles for recent releases

```
$ ./roswell/update.sh
$ ./sbcl/update.sh
```

### Generate GitHub Actions

```
$ ./generate-build-actions.sh
```
