FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

SHELL ["/bin/bash", "-c"]

ENV ELM_VERSION=0.18.0
ENV SBT_VERSION=0.13.15
ENV SCALA_VERSION=2.11.11

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install apt-utils

RUN apt-get -y install locales
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get -y install autoconf && \
  apt-get -y install automake && \
  apt-get -y install curl && \
  apt-get -y install git && \
  apt-get -y install libffi-dev && \
  apt-get -y install libncurses-dev && \
  apt-get -y install libreadline-dev && \
  apt-get -y install libssl-dev && \
  apt-get -y install libtool && \
  apt-get -y install libxslt-dev && \
  apt-get -y install libyaml-dev && \
  apt-get -y install openjdk-8-jdk && \
  apt-get -y install unixodbc-dev && \
  apt-get -y install vim

ENV HOME /root

RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.4.0
RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> $HOME/.bashrc
RUN echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> $HOME/.bashrc

ENV ASDF_DIR $HOME/.asdf
ENV PATH ${ASDF_DIR}/bin:${ASDF_DIR}/shims:$PATH

RUN asdf plugin-add elm && \
  asdf plugin-add sbt https://github.com/vpeurala/asdf-sbt && \
  asdf plugin-add scala && \
  asdf install elm ${ELM_VERSION} && \
  asdf install sbt ${SBT_VERSION} && \
  asdf install scala ${SCALA_VERSION} && \
  asdf global elm ${ELM_VERSION} && \
  asdf global sbt ${SBT_VERSION} && \
  asdf global scala ${SCALA_VERSION}

# ENV SBT_HOME=/downloads/sbt
# ENV PATH=$PATH:${SBT_HOME}/bin
# ENV SCALA_HOME=/downloads/scala-${SCALA_VERSION}
# ENV PATH=$PATH:${SCALA_HOME}/bin

# Fill the caches
# COPY warmup /warmup
# WORKDIR /warmup
# RUN mkdir -p /root/.ivy2/local
# RUN cp -R /downloads/sbt/lib/local-preloaded/* /root/.ivy2/local/
# RUN sbt update
# Sometimes this is left after `sbt update`: a bug in sbt, maybe?
# RUN rm -rf /root/.ivy2/.sbt.ivy.lock

# Install Elm

# RUN npm install -g elm
# RUN elm-package install
