LOG_FILE=/tmp/catalogue

echo "Download NodeJS package"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
if [ $? -eq 0 ];
then
echo -e status= "\e[32mSUCCESS\e[0m"
else
echo -e status= "\e[31mFAILURE\e[0m"
exit 1
fi

echo "Installing NodeJS package"
yum install nodejs -y &>>${LOG_FILE}
echo status=$?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
echo "Adding roboshop user to the application"
useradd roboshop &>>${LOG_FILE}
echo status=$?
fi

echo "Downloading application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
echo status=$?

cd /home/roboshop

echo " clear previous files/ app data"
rm -rf catalogue catalogue-main &>>${LOG_FILE}
echo status=$?

echo "extracting application code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
echo status=$?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJs Dependencies"
npm install &>>${LOG_FILE}
echo status=$?

echo "Updating Mongodb Ip address in SystemD file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
echo status=$?

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service

echo "catalogue service setup"
systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}
echo status=$?

echo "restarting catalogue service"
systemctl start catalogue &>>${LOG_FILE}
echo status=$?