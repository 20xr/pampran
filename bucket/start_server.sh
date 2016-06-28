#!/usr/bin/env bash

export REDIS_URL=127.0.0.1

LOGDIR=/var/log/papertrail

cd /opt/server/install/package

echo Starting server with forever...
forever start -m 5 -l ${LOGDIR}/serv.log -a lib/index.js &
