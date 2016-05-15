#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

echo Applying pending updates...
yum update -y

echo enable epel repo
sudo yum-config-manager --enable epel
