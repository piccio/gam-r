# GAM-R 

GAM in a containeR

## Intro

### GAM

[GAM](https://github.com/GAM-team/GAM) GAM is a command line tool for Google Workspace admins to manage domain and user settings quickly and easily.

### Executable container

[Docker](https://www.docker.com/) is a tool to easily deploy applications in a sandbox, called containers.<br>
A possible use case is executable container: build a container image that will [run as an executable](https://docs.docker.com/reference/dockerfile/#entrypoint), 
then [run](https://docs.docker.com/engine/containers/run/) a container based on this image.

## Setup

Get the _dockerfile_ and the _gam_ executable.<br>
The _gam_ executable is a shortcut and its purpose is to hide the complexity of the _docker_ layer.

```bash
git clone url path
cd path
```

Build the image from the _Dockerfile_.

```bash
docker build -t gam .
```

Link the _gam_ executable of the project to a host path of your choice (i.e. _gam-r_).

```bash
sudo ln -s $PWD/gam /usr/local/bin/gam-r
```

Check that it works regularly.

```bash
gam-r version
```

will probably respond with a warning message saying that _gam_ is not configured.
