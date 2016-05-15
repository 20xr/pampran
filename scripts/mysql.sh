yum install -y mysql-server
service mysqld start
mysqladmin -u root password "password"

# will be able to connect to mysql with
# mysql -u root --password=password
