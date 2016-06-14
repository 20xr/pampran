#!/usr/bin/env bash
cd /opt/server
export VERSION_ID=`sed -n '1p' < version`
export TARBALL=`sed -n '2p' < version`
export PACKAGE_NAME=`sed -n '3p' < version`

mkdir -p /opt/server/versions
touch /opt/server/versions/${VERSION_ID}

mkdir -p /opt/server/install
cd install
#tar xf /opt/server/${TARBALL}
#cd ${PACKAGE_NAME}
echo Installing server with npm...
npm install /opt/server/${TARBALL}
