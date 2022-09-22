LOG_FILE=/tmp/shipping
Source common.sh

echo "Installing Maven package"
yum install maven -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
  echo "Adding roboshop user to the application"
  useradd roboshop &>>${LOG_FILE}
  StatusCheck $?
  fi

cd /home/roboshop

echo "Downloading schema"
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
StatusCheck $?

cd /tmp
rm -rf shipping-main

echo "extracting schema"
unzip /tmp/shipping.zip
StatusCheck $?

mv shipping-main shipping
cd shipping

echo "remove all the files from previous builds"
mvn clean package
StatusCheck $?

mv target/shipping-1.0.jar shipping.jar

echo "updating systemd service files"
sed -i -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/shipping/systemd.service
StatusCheck $?

mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service

echo "setting up shipping service"
systemctl daemon-reload
systemctl enable shipping
StatusCheck $?

echo "Restarting shipping service"
systemctl restart shipping
StatusCheck $?