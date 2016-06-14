export REDIS_URL=127.0.0.1:6379

LOGDIR=/var/log/papertrail/

cd /opt/server/install/package

forever start -m 5 -a -l ${LOGDIR}/forever.log -o ${LOGDIR}/out.log -e ${LOGDIR}/err.log -c "npm start" ./ &
