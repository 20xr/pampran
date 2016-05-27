yum install -y telnet
# yum install -y tcl  # if tests are needed

wget http://download.redis.io/releases/redis-3.2.0.tar.gz
tar xzf redis-3.2.0.tar.gz
cd redis-3.2.0
make
#make test
make install
cd utils
chmod +x install_server.sh

PORT=6379
CONFIG_FILE=/etc/redis/6379.conf
LOG_FILE=/var/log/redis_6379.log
DATA_DIR=/var/lib/redis/6379
EXECUTABLE=/usr/local/bin/redis-server

echo -e \
  "${PORT}\n${CONFIG_FILE}\n${LOG_FILE}\n${DATA_DIR}\n${EXECUTABLE}\n" | \
  ./install_server.sh

# this installs redis_6379 as a service
