#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

echo Install common npm packages we know we will need

cd ~
npm install mysql ioredis lodash async aws-sdk
npm install -g forever
