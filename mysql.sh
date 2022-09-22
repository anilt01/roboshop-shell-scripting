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
systemctl start mysqld &>>${LOG_FILE}
StatusCheck $?

echo "declaring the default password"
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
StatusCheck $?

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${ROBOSHOP_MYSQL_PASSWORD}');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql

echo "show databases" |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  echo "Change the default password"
mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql &>>${LOG_FILE}
StatusCheck $?
fi

echo 'show plugins' | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} | grep 'validate_password' &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo "uninstall password plugin validation"
  echo "uninstall plugin validate_password;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>${LOG_FILE}
fi

# uninstall plugin validate_password;
echo "download schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?
cd /tmp
rm -rf mysql-main
echo "extracting schema"
unzip mysql.zip &>>${LOG_FILE}
StatusCheck $?

echo "load schema"
cd mysql-main
mysql -u root -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql
StatusCheck $?