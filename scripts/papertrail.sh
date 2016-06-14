#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

echo Downloading papertrail remote_syslog...
wget https://github.com/papertrail/remote_syslog2/releases/download/v0.17/remote_syslog_linux_amd64.tar.gz

tar xzf remote_syslog*.tar.gz
rm remote_syslog*.tar.gz

echo Installing remote_syslog...
mkdir /opt/papertrail
mv remote_syslog /opt/papertrail

cat << EOF > /etc/rsyslog.d/90-papertrail.conf
*.*          @${PAPERTRAIL_HOST}:${PAPERTRAIL_PORT}
EOF
chmod 644 /etc/rsyslog.d/90-papertrail.conf

cat << EOF > /etc/log_files.yml
destination:
  host: ${PAPERTRAIL_HOST}
  port: ${PAPERTRAIL_PORT}
  protocol: tls
files:
  - /var/log/cloud-init.log
  - /var/log/cloud-init-output.log
  - /var/log/rc.local.log
  - /var/log/newrelic/*.log
  - /var/log/papertrail/*.log
EOF
chmod 644 /etc/log_files.yml
