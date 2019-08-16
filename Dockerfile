FROM debian:stretch

RUN apt-get update --fix-missing && apt-get install -y sudo

ARG USER=mcarter
RUN adduser --home /home/${USER} --disabled-password --gecos GECOS ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} \
  && chmod 0440 /etc/sudoers.d/${USER} \
  && groupadd docker \
  && usermod -aG docker ${USER}

USER ${USER}
ENV USER=${USER}
ENV HOME=/home/${USER}

RUN mkdir -p ${HOME}/.ssh

# system
RUN sudo apt-get install -y \
      zsh \
      locales \
      procps \
      gnupg \
      tmux \
      curl \
      git \
      vim

RUN sudo apt-get autoremove -y \
    && sudo apt-get clean -y

# Set the locale to utf8
RUN sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
      && sudo locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Set zsh as default
RUN sudo chsh -s /bin/zsh ${USER}

# fix permissions on diff-highlight
RUN sudo chmod 555 /usr/share/doc/git/contrib/diff-highlight/diff-highlight

ENV DEV=${HOME}/dev
ENV DEVENV=${DEV}/devenv
ENV DOTFILES=${DEVENV}/dotfiles

RUN mkdir -p ${DEV}
RUN mkdir -p ${DEVENV}

# oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh ${HOME}/.oh-my-zsh

# dotfiles
RUN ln -s ${DOTFILES}/zprofile ${HOME}/.zprofile
RUN ln -s ${DOTFILES}/zshrc ${HOME}/.zshrc
RUN ln -s ${DOTFILES}/tmux.conf ${HOME}/.tmux.conf
RUN ln -s ${DOTFILES}/gitconfig ${HOME}/.gitconfig
RUN ln -s ${DOTFILES}/vimrc ${HOME}/.vimrc

WORKDIR ${DEV}

ENTRYPOINT ["tmux", "new"]
