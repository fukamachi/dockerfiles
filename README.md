# Dockerfiles for Common Lisp programming

## Docker Hub Links

- [fukamachi/roswell](https://hub.docker.com/r/fukamachi/roswell)
- [fukamachi/sbcl](https://hub.docker.com/r/fukamachi/sbcl)

## Developer notes

### Generate Dockerfiles for recent releases

```
$ ./roswell/update.sh
$ ./sbcl/update.sh
```

### Generate GitHub Actions

```
$ ./generate-build-actions.sh
```
