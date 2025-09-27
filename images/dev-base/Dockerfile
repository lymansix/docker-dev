ARG UBUNTU_RELEASE=noble

FROM docker.io/library/ubuntu:${UBUNTU_RELEASE} as base

RUN apt-get update && \
	apt-get install sudo adduser vim -y && \
	adduser --disabled-password --gecos '' lymansix && \
	adduser lymansix sudo && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

LABEL MAINTAINER zhaowangliu58@126.com

ENV UBUNTU_RELEASE=${UBUNTU_RELEASE}

# {{{ lang stuff

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
RUN apt-get update && \
	apt-get install -y language-pack-en-base && \
	rm -rf /var/lib/apt/lists/*

# }}}

# Required for `clear` command to work, etc.
ENV TERM screen-256color

ENV USER lymansix

ENV HOME /home/lymansix

WORKDIR /home/lymansix

USER lymansix

COPY build.sh /tmp/build.sh

COPY zshrc /tmp/zshrc

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

COPY ./inputrc "$HOME/.inputrc"

RUN sudo chown "$USER":"$USER" "$HOME/.inputrc"

CMD ["sudo /usr/sbin/sshd", "-D"]

ENV XDG_CONFIG_HOME "$HOME/.config"

ENV TMUX_VERSION 3.1

COPY ./tmux.conf "$HOME/.config/tmux/tmux.conf"
COPY ./tmux-setup.sh /tmp/tmux-setup.sh

RUN bash /tmp/tmux-setup.sh && sudo rm /tmp/tmux-setup.sh

ENV IMAGE_CLASS=base

# fixes potential permission issues
RUN mkdir -p ~/workspace
