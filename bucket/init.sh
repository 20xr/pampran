#!/usr/bin/env bash
source /opt/env.sh

aws elasticache describe-cache-clusters \
    --cache-cluster-id ${CACHE_CLUSTER} \
    --show-cache-node-info

/opt/server/install_server.sh
/opt/server/start_server.sh
/opt/server/repeat_poll.sh
