LOG_FILE=/tmp/catalogue

echo "Download NodeJS package"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
echo Status=$?

echo "Installing NodeJs"
yum install nodejs -y &>>$LOG_FILE
echo status=$?

echo "Adding roboshop user"
useradd roboshop &>>$LOG_FILE
echo status=$?

echo "Download Catalogue Application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
echo status=$?

cd /home/roboshop
echo "extracting catalogue application code"
unzip /tmp/catalogue.zip &>>$LOG_FILE
echo status=$?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJS dependencies"
npm install &>>$LOG_FILE
echo status=$?

echo "update systemd files with mongodb address"
sed -i -e 's/MONGO_DNSNAME/mogodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>LOG_FILE
echo status=$?

echo "setup catalogue service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
echo status=$?

systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE
echo "restart catalogue service"
systemctl restart catalogue &>>$LOG_FILE
echo status=$?