FROM debian:stretch

ENV HOME=/root

RUN apt-get update
RUN apt-get install -y \
      zsh \
      locales \
      vim \
      tmux
RUN apt-get autoremove -y \
    && apt-get clean -y

# Set the locale to utf8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR ${HOME}

# development directory
RUN mkdir ${HOME}/dev

ENTRYPOINT ["tmux", "new"]
