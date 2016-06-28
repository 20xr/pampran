#!/usr/bin/env bash
source /opt/env.sh
/opt/server/install_server.sh
/opt/server/start_server.sh
/opt/server/repeat_poll.sh
