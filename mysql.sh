LOG_FILE=/tmp/mysql
source common.sh

echo "Downloading mysql repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
StatusCheck $?

echo "disabling previous mysql module"
dnf module disable mysql -y &>>${LOG_FILE}
StatusCheck $?

echo "Installing the required community mysql server"
yum install mysql-community-server -y &>>${LOG_FILE}
StatusCheck $?

echo "enable mysql server"
systemctl enable mysqld &>>${LOG_FILE}
StatusCheck $?

echo "restarting the server"
systemctl start mysqld
StatusCheck $?

echo "declaring the default password"
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
StatusCheck $?

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD($'{ROBOSHOP_MYSQL_PASSWORD}');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql

echo "login to mysql server"
mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} </tmp/root-pass.sql
StatusCheck $?

# mysql_secure_installation
# mysql -uroot -pRoboShop@1
## IN MY SQL>
# uninstall plugin validate_password;
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql