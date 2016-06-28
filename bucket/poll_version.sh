#!/usr/bin/env bash

# copy the latest version file from s3 bucket
/opt/cp_s3.sh version
export VERSION_ID=`sed -n '1p' < /opt/server/version`

# when VERSION_ID is new, move old code aside and sync new code
if [ ! -f /opt/server/versions/${VERSION_ID} ]; then

  echo New version in bucket: ${VERSION_ID}

  # sync to get all up-to-date files from s3 bucket
  /opt/sync_bucket.sh
  chmod +x /opt/server/*.sh

  # move currently running server out of the way
  rm -rf /opt/server/old_install
  mv /opt/server/install /opt/server/old_install

  # install server package
  /opt/server/install_server.sh

  # kill existing server before restarting
  forever stopall

  # restart server monitor
  /opt/server/start_server.sh

fi
