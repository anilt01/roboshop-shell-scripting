source common.sh
LOG_FILE=/tmp/redis

echo "Downloading redis remi package"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG_FILE}
StatusCheck $?

echo "enabling redis version 6.2"
dnf module enable redis:remi-6.2 -y &>>${LOG_FILE}
StatusCheck $?

echo "Installing redis package"
yum install redis -y &>>${LOG_FILE}
StatusCheck $?

echo "updating Listen address in config files"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG_FILE}
StatusCheck $?
## Update the `bind` from 127.0.0.1 to 0.0.0.0` in config file /etc/redis.conf` & `/etc/redis/redis.conf` &>>${LOG_FILE}

echo "enable and restart redis"
systemctl enable redis &>>${LOG_FILE}
systemctl restart redis &>>${LOG_FILE}
StatusCheck $?