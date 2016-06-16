#!/usr/bin/env bash

export REDIS_URL=127.0.0.1:6379

LOGDIR=/var/log/papertrail

cd /opt/server/install/package

echo Starting server with forever...
forever start -m 5 -l ${LOGDIR}/serv.log -a lib/main.js &
