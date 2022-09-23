LOG_FILE=/tmp/shipping
source common.sh

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
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /tmp/shipping
rm -rf shipping-main shipping &>>${LOG_FILE}

echo "extracting schema"
unzip /tmp/shipping.zip &>>${LOG_FILE}
StatusCheck $?

mv shipping-main shipping
StatusCheck $?

cd shipping

echo "remove all the files from previous builds"
mvn clean package ${LOG_FILE}
StatusCheck $?

mv target/shipping-1.0.jar shipping.jar

echo "updating systemd service files"
sed -i -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/shipping/systemd.service &>>${LOG_FILE}
StatusCheck $?

mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service

echo "setting up shipping service"
systemctl daemon-reload &>>${LOG_FILE}
systemctl enable shipping &>>${LOG_FILE}
StatusCheck $?

echo "Restarting shipping service"
systemctl restart shipping &>>${LOG_FILE}
StatusCheck $?