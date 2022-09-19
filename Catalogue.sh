
LOG_FILE=/tmp/catalogue

echo "Downloading NodeJS package"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
echo status=$?

echo "Installing NodeJs package"
yum install nodejs -y &>>${LOG_FILE}
echo status=$?

echo "Adding User roboshop in the application"
useradd roboshop &>>${LOG_FILE}
echo status=$?

echo "downloading catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
echo status=$?

cd /home/roboshop

echo "extracting the catalogue application code"
unzip /tmp/catalogue.zip -y &>>${LOG_FILE}
echo status=$?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Installing catalogue application code"
npm install &>>${LOG_FILE}
echo status=$?

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}

echo "restarting catalogue service"
systemctl restart catalogue &>>${LOG_FILE}
echo status=$?