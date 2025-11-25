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

```bash
git clone url path
```

```bash
cd path
docker build -t gam .
```

```bash
sudo ln -s $PWD/gam /usr/local/bin/gam-r
```

```bash
gam-r version
```
