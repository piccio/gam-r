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

Note: It will likely respond with a warning message stating that _gam_ is not configured.

## GAM Config

Check the [prerequisites](https://github.com/GAM-team/GAM/wiki/Authorization#introduction) and then follow these steps:
- [create a GAM project w/o local browser](https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#create-your-project-without-local-browser-google-cloud-shell-for-instance)
- [enable GAM7 client access](https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#enable-gam7-client-access)
- [enable GAM7 service account access](https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#enable-gam7-service-account-access)
- [config GAM7](https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#update-gamcfg-with-some-basic-values)

For more information, see [authorization](https://github.com/GAM-team/GAM/wiki/Authorization)

## GAM directories

The _gam_ configuration and working [directories](https://github.com/GAM-team/GAM/wiki/gam.cfg#introduction) (_GamConfigDir_ and _GamDriveDir_, respectively) are mounted through _docker volumes_ and managed by _docker desktop_.
The volumes are named gam_cfg_dir and gam_drive_dir respectively.

### Copy files from host to container

Mount a local host folder on a container folder to enable copying files from the host to the container and vice versa.

```bash
docker run --rm -it \
  -v ~/Downloads/gam:/tmp/host_downloads \
  -v gam_drive_dir:/home/gam/Downloads \
  --entrypoint "" \
  gam bash -c "cp /tmp/host_downloads/ticket-20241001210236.csv Downloads/"
```

For example if the credential files are already on the host, you can copy them to the volume before to invoke gam commands

```bash
docker run --rm -it \
  -v ~/.gam:/tmp/host_gam_cfg \
  -v gam_cfg_dir:/home/gam/.gam \
  --entrypoint "" \
  gam bash -c "cp /tmp/host_gam_cfg/* .gam/"
```

## Update

To update gam simply rebuild the image

```bash
docker rmi gam
docker build -t gam .
```

## Shell

Open a shell inside the container

```bash
docker run --name gam-bash --rm -ti --entrypoint "/bin/bash" gam
```

or with volumes mounted

```bash
GAM_USER=$(docker run --rm -it --entrypoint '' gam whoami | tr -d '[:space:]' )

docker run --rm -it \
  -v gam_cfg_dir:/home/"${GAM_USER}"/.gam \
  -v gam_drive_dir:/home/"${GAM_USER}"/Downloads \
  --name gam-bash \
  --entrypoint "/bin/bash" gam
```
