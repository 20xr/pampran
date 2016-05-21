#!/usr/bin/env bash
set -o errexit -o pipefail -o nounset
# set -o xtrace

echo Copying files from temporary location to root...
cd /tmp/files
cp -R . /

echo Removing temporary location....
rm -rf /tmp/files

echo Apply permissions to files...
chmod 755 /etc/rc.d/rc.local
chmod 644 /etc/rsyslog.d/90-papertrail.conf
chmod 644 /etc/log_files.yml
chmod 666 /var/log/pampran/pampran.log
chmod 755 /home/ec2-user/aws_init.sh
chmod 755 /home/ec2-user/pollS3.sh
chmod 755 /home/ec2-user/repeatPoll.sh
