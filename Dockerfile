FROM debian:stretch

RUN apt-get update
RUN apt-get install -y \
      zsh \
      locales \
      procps \
      gnupg \
      tmux \
      curl \
      git \
      vim \
      wget \
      sudo
RUN apt-get autoremove -y \
    && apt-get clean -y


ARG USER=mcarter
RUN adduser --home /home/${USER} --disabled-password --gecos GECOS ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} \
  && chmod 0440 /etc/sudoers.d/${USER} \
  && groupadd docker \
  && usermod -aG docker ${USER}

# Set the locale to utf8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
      && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set zsh as default
RUN chsh -s /bin/zsh ${USER}

# fix permissions on diff-highlight
RUN chmod 544 /usr/share/doc/git/contrib/diff-highlight/diff-highlight

USER ${USER}
ENV USER=${USER}
ENV HOME=/home/${USER}
ENV LOCAL=${HOME}/local
ENV DEV=${HOME}/dev

RUN mkdir -p ${LOCAL}/bin \
      && mkdir -p ${DEV}
ENV PATH=${PATH}:${LOCAL}/bin

# oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh ${HOME}/.oh-my-zsh

# dotfiles
RUN ln -s ${DEV}/devenv/dotfiles/zshrc ${HOME}/.zshrc
RUN ln -s ${DEV}/devenv/dotfiles/tmux.conf ${HOME}/.tmux.conf
RUN ln -s ${DEV}/devenv/dotfiles/gitconfig ${HOME}/.gitconfig
RUN ln -s ${DEV}/devenv/dotfiles/vimrc ${HOME}/.vimrc

RUN mkdir -p ${DEV}
WORKDIR ${DEV}

ENTRYPOINT ["tmux", "new"]
