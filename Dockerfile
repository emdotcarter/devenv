FROM debian:stretch

ENV HOME=/root

RUN apt-get update
RUN apt-get install -y \
      zsh \
      locales \
      tmux \
      curl \
      git \
      vim
RUN apt-get autoremove -y \
    && apt-get clean -y

# Set the locale to utf8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set zsh as default
RUN chsh -s /bin/zsh root

# oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh ${HOME}/.oh-my-zsh

WORKDIR ${HOME}
RUN mkdir ${HOME}/dev

# dotfiles
RUN ln -s ${HOME}/dev/devenv/dotfiles/zshrc ${HOME}/.zshrc

ENTRYPOINT ["tmux", "new"]
