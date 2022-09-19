source common.sh

echo "Downloading redis remi package"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
Statuscheck $?

echo "enabling redis version 6.2"
dnf module enable redis:remi-6.2 -y
Statuscheck $?

echo "Installing redis package"
yum install redis -y
Statuscheck $?

echo "updating Listen address in config files"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
Statuscheck $?
## Update the `bind` from 127.0.0.1 to 0.0.0.0` in config file /etc/redis.conf` & `/etc/redis/redis.conf`

echo "enable and restart redis"
systemctl enable redis
systemctl restart redis
Statuscheck $?