# Docker

My collection of docker images.

## Building

Building is based on a simple Makefile. To inspect which images are supported type:

```
make help
Cleaning targets:
	clean			Removes all built docker images;
	rm_ubuntu-dev-18.04     Removes ubuntu-dev-18.04 image;
	rm_glade-3              Removes glade-3 image;

Build targets:
	all 			Default target. Build all images;
	ubuntu-dev-18.04	Build ubuntu18.04 based imaged with minimal set of dev tools;
	glade-3			Build image to run glade-3;
```

## Running

To run your image, I personally like to run it like:

```
docker run --rm -ti -v $HOME:$HOME -v $PWD:$PWD -w $PWD -u $UID docker_image args
```

### GUI Applications

To run GUI based applications under a docker image, some special arguments are needed. We need to set the DISPLAY environment variable and share the x11 sockets. Hence:

```
docker run --rm -ti -e DISPLAY=:1 -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v $HOME:$HOME -v $PWD:$PWD -w $PWD -u $UID docker_image args
```
