# Dockerfiles for Common Lisp programming

Dockerfiles for each version of Common Lisp implementations and utilities. Currently provides the following products:

- [Roswell](https://github.com/roswell/roswell), a Common Lisp implementation manager  
  [![Docker Pulls](https://img.shields.io/docker/pulls/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)
  [![Docker Stars](https://img.shields.io/docker/stars/fukamachi/roswell.svg)](https://hub.docker.com/r/fukamachi/roswell/)
- [SBCL](http://sbcl.org), a high-performance Common Lisp compiler  
  [![Docker Pulls](https://img.shields.io/docker/pulls/fukamachi/sbcl.svg)](https://hub.docker.com/r/fukamachi/sbcl/)
  [![Docker Stars](https://img.shields.io/docker/stars/fukamachi/sbcl.svg)](https://hub.docker.com/r/fukamachi/sbcl/)
- [Clozure CL](https://ccl.clozure.com/), an open source Common Lisp implementation hosted by Clozure Associates  
  [![Docker Pulls](https://img.shields.io/docker/pulls/fukamachi/ccl.svg)](https://hub.docker.com/r/fukamachi/ccl/)
  [![Docker Stars](https://img.shields.io/docker/stars/fukamachi/ccl.svg)](https://hub.docker.com/r/fukamachi/ccl/)

## Usage

### Fetching from Docker Hub

Build images are also available on Docker Hub.

```shell
$ docker run -it --rm fukamachi/sbcl
* (lisp-implementation-type)
"SBCL"
* (lisp-implementation-version)
"2.0.0"
```

### Building by your own

```shell
$ git clone https://github.com/fukamachi/dockerfiles
$ cd dockerfiles

# Build SBCL 2.0.0 image (Debian)
$ sbcl/build.sh 2.0.0 debian
# Build SBCL 2.0.0 image (Alpine)
$ sbcl/build.sh 2.0.0 alpine

# Start a REPL
$ docker run -it --rm sbcl:2.0.0-debian
* (lisp-implementation-type)
"SBCL"
* (lisp-implementation-version)
"2.0.0"
```

## Fork

To make GitHub Actions work, add the following secrets` to your forked GitHub repository.

- DOCKER_HUB_PASSWORD
  - Password for Docker Hub
- AUTO_UPDATE_GITHUB_TOKEN
  - GitHub personal token to check the newer versions and create a pull request

See [GitHub's document](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets).
