#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

echo Copying files from temporary location to root...
cd /tmp/files
cp -R . /

echo Removing temporary location....
rm -rf /tmp/files

echo Apply permissions to files...
chmod 755 /etc/rc.d/rc.local
