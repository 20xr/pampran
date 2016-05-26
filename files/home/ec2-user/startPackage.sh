cd $HOME
LOGDIR=/var/log/papertrail
FOREVER=~/node_modules/forever/bin/forever

if [ -f version ]; then
  DEPLOY_DIR=`sed -n '1p' < version`
  TARBALL=`sed -n '2p' < version`
  PACKAGE=`sed -n '3p' < version`

  EXISTING_SERVER=$(pgrep -f forever/bin/monitor)
  if [ -z EXISTING_SERVER ]; then
    cd ${DEPLOY_DIR}/node_modules/${PACKAGE}
    ${FOREVER} start -a -o ${LOGDIR}/out.log -e ${LOGDIR}/err.log -l ${LOGDIR}/forever.log -c "npm start" ./ &
  fi
fi
