# GAM-R 

GAM in a containeR

## Intro

### GAM / GAMADV

GAMADV-XTD3 is a free, open source CLI (command line tool) to manage Google Workspace.

GAMADV-XTD3 is a rewrite/extension of Jay Lee's [GAM](https://github.com/jay0lee/GAM/)

### Executable container

Docker is a tool to easily deploy applications in a sandbox, called containers.

Build a container image that will [run as an executable](https://docs.docker.com/reference/dockerfile/#entrypoint), 
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
