#!/bin/sh
cd $HOME

aws s3 cp s3://${TAR_BUCKET}/version .
DEPLOY_DIR=`sed -n '1p' < version`
TARBALL=`sed -n '2p' < version`
PACKAGE=`sed -n '3p' < version`

if [ ! -e install ]; then
    mkdir install
fi
cd install
if [ -e ${DEPLOY_DIR} ]; then
    # already installed this version
    exit 0
fi
mkdir ${DEPLOY_DIR}
cd ${DEPLOY_DIR}
aws s3 cp s3://${TAR_BUCKET}/${TARBALL} .
tar xf ${TARBALL}
npm install

# kill existing server before restarting
pkill -f forever/bin/monitor

$HOME/startPackage.sh
