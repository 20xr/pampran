#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

yum groupinstall -y "Development Tools"
