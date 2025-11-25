# FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
# initializes a new build stage and sets the base image for subsequent instructions
FROM python:3.14-slim

# LABEL <key>=<value> <key>=<value> <key>=<value> ...
# adds metadata to an image
LABEL org.opencontainers.image.authors="roberto.piccini@gmail.com roberto.piccini@unife.it"

# ARG <name>[=<default value>]
# defines a variable that users can pass at build-time to the builder
#   If has a default value and if there is no value passed at build-time, the builder uses the default.
ARG USER=gam

# ENV <key>=<value> ...
# sets the environment variable <key> to the value <value>
#   The environment variables set using ENV will persist when a container is run from the resulting image
ENV HOME=/home/$USER
ENV GAM_INSTALLER=$HOME/gam-install
ENV GAMDRIVEDIR=$HOME/Download
#ENV GAMDRIVEDIR=$HOME/gam_work
ENV GAMCFGDIR=$HOME/.gam
#ENV GAMCFGDIR=$HOME/gam_config
ENV BASH_CONFIG_FILE=$HOME/.bashrc

# RUN [OPTIONS] <command> ...
# execute any commands to create a new layer on top of the current image.
#   The added layer is used in the next step in the Dockerfile
# RUN as root
### prerequisites
RUN adduser --disabled-login $USER
RUN apt update && apt install -y \
    curl \
    xz-utils \
    less \
    vim
### get gam
# curl options:
#   -s, --silent
#     Silent or quiet mode. Do not show progress meter or error messages.
#       Use -S, --show-error in addition to this option to disable progress meter but still show error messages.
#   -S, --show-error
#     When used with -s, --silent, it makes curl show an error message if it fails.
#   -L, --location
#     (HTTP) If the server reports that the requested page has moved to a different location,
#       this option makes curl redo the request on the new place.
#   -o, --output <file>
#     Write output to <file> instead of stdout.
RUN curl -s -S -L -o $GAM_INSTALLER https://gam-shortn.appspot.com/gam-install
RUN chown $USER $GAM_INSTALLER
RUN chmod 700 $GAM_INSTALLER
### set a configuration directory (https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#set-a-configuration-directory)
RUN mkdir $GAMCFGDIR
RUN chown $USER $GAMCFGDIR
RUN echo "export GAMCFGDIR=$GAMCFGDIR" >> $BASH_CONFIG_FILE
### Set a working directory (https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#set-a-working-directory)
RUN mkdir $GAMDRIVEDIR
RUN chown $USER $GAMDRIVEDIR
RUN echo "export GAMDRIVEDIR=$GAMDRIVEDIR" >> $BASH_CONFIG_FILE
# The default shell on Linux is sh so use the dot operator in place of source,
#   which is the sh equivalent of the bash source command
#RUN source $BASH_CONFIG_FILE
RUN . $BASH_CONFIG_FILE

# USER <user>[:<group>]
# sets the user name (or UID) and optionally the user group (or GID) to use as the default user and group for
#   the remainder of the current stage. The specified user is used for RUN instructions and at runtime,
#   runs the relevant ENTRYPOINT and CMD commands
USER $USER
# WORKDIR /path/to/workdir
# sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile
WORKDIR $HOME

# RUN as $USER
# Docker executes these commands using the /bin/sh -c interpreter,
#   which only evaluates the exit code of the last operation in the pipe to determine success
#   If you want the command to fail due to an error at any stage in the pipe, prepend `set -o pipefail &&`
### install gam
#RUN ( while true ; do echo "no" ; done ) | $GAM_INSTALLER
### do it better (and KISS) :-)
RUN $GAM_INSTALLER -l
### set a symlink (https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#set-a-symlink)
USER root
RUN ln -s $HOME/bin/gam7/gam /usr/local/bin/gam
USER $USER
### Initialize GAM7; this should be the first GAM7 command executed
###   (https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#initialize-gam7-this-should-be-the-first-gam7-command-executed)
RUN gam config drive_dir $GAMDRIVEDIR verify
### set gam to be configured without local browser
###  (https://github.com/GAM-team/GAM/wiki/How-to-Install-GAM7#create-your-project-without-local-browser-google-cloud-shell-for-instance)
RUN gam config no_browser true save

# VOLUME ["/data"]
# creates a mount point with the specified name and marks it as holding externally mounted volumes
#   from native host or other containers.
VOLUME ["$GAMCFGDIR"]
VOLUME ["$GAMDRIVEDIR"]

# ENTRYPOINT ["executable", "param1", "param2"]
# configures a container that will run as an executable
ENTRYPOINT ["gam"]
