FROM ubuntu:18.04
MAINTAINER Cheng JIANG <alex_cj96@foxmail.com>

ARG APP_USER=alex_cj96

ENV DEBIAN_FRONTEND noninteractive

RUN useradd ${APP_USER} --user-group --create-home --shell /bin/bash --groups sudo

RUN apt update --fix-missing \
    && apt install -y \
        libssl-dev \
        git \
        wget \
        curl \
        build-essential \
        libncurses5-dev \
        libncursesw5-dev \
        debhelper \
        inotify-tools \
        xz-utils \
        gawk \
        unzip \
        zlib1g-dev \
        sudo \
        ninja-build \
        autoconf \
        automake \
        libtool \
        python3-dev \
        python3-pip \
        tmux \
        clang-format \
        cppcheck \
        ruby \
        ruby-dev \
        apt-file \
        openssh-client \
        openssh-server \
        jq \
        zsh \
        apt-transport-https \
        openjdk-8-jdk \
        protobuf-compiler \
        software-properties-common \
        ca-certificates \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo '%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${APP_USER}
WORKDIR /home/${APP_USER}
RUN mkdir -p /home/${APP_USER}/src

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && curl https://raw.githubusercontent.com/GopherJ/cfg/master/zshrc/.zshrc --retry-delay 2 --retry 3 >> ~/.zshrc

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
    && echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.zshrc \
    && /home/linuxbrew/.linuxbrew/bin/brew install watchman \
    && echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

RUN wget https://cmake.org/files/v3.18/cmake-3.18.4.tar.gz \
    && tar -xzvf cmake-3.18.4.tar.gz \
    && cd cmake-3.18.4 \
    && ./bootstrap \
    && make -j4 \
    && sudo make install

WORKDIR /home/${APP_USER}/src
