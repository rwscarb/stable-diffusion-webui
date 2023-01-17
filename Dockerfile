FROM nvidia/cuda:11.3.1-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq --fix-missing && \
    apt-get install -y \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        ffmpeg \
        libsm6 \
        libxext6 \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncursesw5-dev \
        libffi-dev \
        liblzma-dev \
        build-essential \
        curl \
        libssl-dev \
        pciutils \
        git

ARG GROUP_ID
ARG USER_ID
ARG USER_NAME
ARG PYTHON_VERSION

RUN groupadd --gid $GROUP_ID $USER_NAME
RUN useradd --create-home --no-log-init --uid $USER_ID --gid $GROUP_ID $USER_NAME

USER $USER_ID

ENV HOME /home/$USER_NAME

RUN curl https://pyenv.run | bash
ENV PATH=$HOME/.pyenv/bin:$HOME/.local/bin:$PATH

RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION

RUN echo 'eval "$(pyenv init --path)"' >> $HOME/.profile
RUN echo 'eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc

ENV pip_cmd=$HOME/.pyenv/shims/pip
RUN $pip_cmd install virtualenv
ENV python_cmd=$HOME/.pyenv/shims/python
