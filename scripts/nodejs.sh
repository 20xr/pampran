#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace
cd /tmp
wget https://nodejs.org/dist/v6.1.0/node-v6.1.0-linux-x64.tar.xz
tar -C /usr/local --strip-components 1 -xJf node-v6.1.0-linux-x64.tar.xz

# /usr/local/bin/npm install -g forever
