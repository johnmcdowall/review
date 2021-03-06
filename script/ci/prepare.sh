#!/bin/bash

set -e

export ERLANG_VERSION=$(cat elixir_buildpack.config | grep erlang_version | tr "=" " " | awk '{ print $2 }')
export ELIXIR_VERSION=v$(cat elixir_buildpack.config | grep elixir_version | tr "=" " " | awk '{ print $2 }')
export INSTALL_PATH="$HOME/dependencies"

export ERLANG_PATH="$INSTALL_PATH/otp_src_$ERLANG_VERSION"
export ELIXIR_PATH="$INSTALL_PATH/elixir_$ELIXIR_VERSION"

mkdir -p $INSTALL_PATH
cd $INSTALL_PATH

# Install erlang
if [ ! -e $ERLANG_PATH/bin/erl ]; then
  curl -O http://erlang.org/download/otp_src_$ERLANG_VERSION.tar.gz
  tar xzf otp_src_$ERLANG_VERSION.tar.gz
  cd $ERLANG_PATH
  ./configure --enable-smp-support \
              --enable-m64-build \
              --disable-native-libs \
              --disable-sctp \
              --enable-threads \
              --enable-kernel-poll \
              --disable-hipe \
              --without-javac
  make

  # Symlink to make it easier to setup PATH to run tests
  ln -sf $ERLANG_PATH $INSTALL_PATH/erlang
fi

# Install elixir
export PATH="$ERLANG_PATH/bin:$PATH"

if [ ! -e $ELIXIR_PATH/bin/elixir ]; then
  git clone https://github.com/elixir-lang/elixir $ELIXIR_PATH
  cd $ELIXIR_PATH
  git checkout $ELIXIR_VERSION
  make

  # Symlink to make it easier to setup PATH to run tests
  ln -sf $ELIXIR_PATH $INSTALL_PATH/elixir
fi

export PATH="$ERLANG_PATH/bin:$ELIXIR_PATH/bin:$PATH"

# Install package tools
if [ ! -e $HOME/.mix/rebar ]; then
  yes Y | LC_ALL=en_GB.UTF-8 mix local.hex
  yes Y | LC_ALL=en_GB.UTF-8 mix local.rebar
fi

PHANTOMJS_VERSION=phantomjs-2.1.1-linux-x86_64
PHANTOMJS_PATH=$HOME/$PHANTOMJS_VERSION
PHANTOMJS_SHA="86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f"
PHANTOMJS_INSTALL_PATH=$HOME/dependencies/phantomjs

if [ ! -e $PHANTOMJS_INSTALL_PATH ]; then
  cd ~
  wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOMJS_VERSION.tar.bz2
  echo "$PHANTOMJS_SHA  phantomjs-2.1.1-linux-x86_64.tar.bz2" | sha256sum -c -
  tar xfj $PHANTOMJS_VERSION.tar.bz2
  cp -rf $PHANTOMJS_PATH $PHANTOMJS_INSTALL_PATH
fi

if [ ! -d $INSTALL_PATH/sysconfcpus/bin ]; then
  git clone https://github.com/obmarg/libsysconfcpus.git
  cd libsysconfcpus
  ./configure --prefix=$INSTALL_PATH/sysconfcpus
  make && make install
  cd ..
fi

# Fetch and compile dependencies and application code (and include testing tools)
cd $HOME/$CIRCLE_PROJECT_REPONAME
script/bootstrap
