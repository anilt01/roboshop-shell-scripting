source common.sh
LOG_FILE=/tmp/user

echo "Download NodeJS package"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?

echo "Installing NodeJS package"
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
echo "Adding roboshop user to the application"
useradd roboshop &>>${LOG_FILE}
StatusCheck $?
fi

echo "Downloading application code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo " clear previous files/ app data"

StatusCheck $?

echo "extracting application code"
unzip /tmp/user.zip &>>${LOG_FILE}
StatusCheck $?

mv user-main user
cd /home/roboshop/user

echo "Installing NodeJS package"
npm install &>>${LOG_FILE}
StatusCheck $?


echo "Updating Redis and Mongodb IP address in SystemD file"
sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  /home/roboshop/user/systemd.service &>>${LOG_FILE}
StatusCheck $?

mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service

echo "user service setup"
systemctl daemon-reload &>>${LOG_FILE}
systemctl enable user &>>${LOG_FILE}
StatusCheck $?

echo "restarting user service"
systemctl restart user &>>${LOG_FILE}
StatusCheck $?
