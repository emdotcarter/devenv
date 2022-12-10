FROM debian:bullseye

ENV TERM xterm-256color

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
RUN sudo apt-get update && sudo apt-get install -y \
      zsh \
      locales \
      procps \
      gnupg \
      tmux \
      curl \
      wget \
      git \
      vim \
      lsb-release \
      build-essential

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

# Install Docker
RUN sudo mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN sudo apt-get update && sudo apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin

ENV DEV=${HOME}/dev
ENV DEVENV=${DEV}/devenv
ENV DOTFILES=${DEVENV}/dotfiles

RUN mkdir -p ${DEV}
RUN mkdir -p ${DEVENV}

# dotfiles
RUN ln -s ${DOTFILES}/zprofile ${HOME}/.zprofile
RUN ln -s ${DOTFILES}/zshrc ${HOME}/.zshrc
RUN ln -s ${DOTFILES}/ssh/config ${HOME}/.ssh/config
RUN ln -s ${DOTFILES}/ssh/ssh_agent_init.sh ${HOME}/.ssh/ssh_agent_init.sh
RUN ln -s ${DOTFILES}/tmux.conf ${HOME}/.tmux.conf
RUN ln -s ${DOTFILES}/gitconfig ${HOME}/.gitconfig
RUN ln -s ${DOTFILES}/vimrc ${HOME}/.vimrc

RUN mkdir -p ${HOME}/.vim
RUN ln -s ${DOTFILES}/vim/ftplugin ${HOME}/.vim/ftplugin

# ohmyzsh
RUN KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

WORKDIR ${DEV}

ENTRYPOINT ["tmux", "new"]
