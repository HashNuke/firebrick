#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y --fix-missing git automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev

git clone https://github.com/HashNuke/asdf.git ~/.asdf
echo 'source $HOME/.asdf/asdf.sh' >> ~/.bashrc
source ~/.bashrc

asdf plugin-add erlang https://github.com/HashNuke/asdf-erlang.git
asdf plugin-add elixir https://github.com/HashNuke/asdf-elixir.git
asdf plugin-add nodejs https://github.com/HashNuke/asdf-nodejs.git

asdf install nodejs 0.12.4
asdf install erlang 17.5
asdf install elixir 1.0.4

cd /vagrant
mix deps.get
