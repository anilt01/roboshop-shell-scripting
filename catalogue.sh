LOG_FILE=/tmp/catalogue

echo "Download NodeJS package"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo status=$?

echo "Installing NodeJS package"
yum install nodejs -y
echo status=$?

echo "Adding roboshop user to the application"
useradd roboshop
echo status=$?

echo "Downloading application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
echo status=?

cd /home/roboshop

echo " clear previous files/ app data"
rm -rf catalogue catalogue-main
echo status=$?

echo "extracting application code"
unzip /tmp/catalogue.zip
echo status=$?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJs Dependencies"
npm install
echo status=$?

echo "Updating Mongodb Ip address in SystemD file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal'
echo status=?

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service

echo "catalogue service setup"
systemctl daemon-reload
systemctl enable catalogue
echo status=$?

echo "restarting catalogue service"
systemctl start catalogue
echo status=$?