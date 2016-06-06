#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

echo enable epel repo
sudo yum-config-manager --enable epel

yum groupinstall -y "Development Tools"
