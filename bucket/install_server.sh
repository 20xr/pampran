#!/bin/sh
cd /opt/server
export TARBALL=`sed -n '2p' < version`
mkdir -p /opt/server/install
cd install
tar xf /opt/server/${TARBALL}
cd package
npm install
