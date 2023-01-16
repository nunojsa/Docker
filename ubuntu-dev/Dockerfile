FROM ubuntu:latest

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make gcc autoconf build-essential  \
		locales locales-all unzip gawk wget python3 python3-pip python3-invoke git \
		net-tools vim lsb-release cmake flex bison libyaml-dev pkg-config swig sudo \
		bc libssl-dev gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi

# set proper locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set bash as default shell
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# not really necessary, just to make it easier to install packages on the run...
RUN useradd -ms /bin/bash docker
RUN echo "docker:docker" | chpasswd && adduser docker sudo

# Add an alias to easily install latest dt-schema. Also make sure $HOME/.local/bin
# is in PATH
RUN echo "export PATH=$PATH:/home/docker/.local/bin" >> /home/docker/.bashrc
COPY bash_aliases /home/docker/.bash_aliases
