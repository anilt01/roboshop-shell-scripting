LOG_FILE=/tmp/payment
source common.sh

echo "Installing python3 software"
yum install python36 gcc python3-devel -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
  if [ $? -ne 0 ]; then
  echo "Adding roboshop user to the application"
  useradd roboshop &>>${LOG_FILE}
  StatusCheck $?
  fi

cd /home/roboshop

echo "Downloading payment schema"
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /tmp/payment
rm -rf payment-main

echo "extracting schema"
unzip /tmp/payment.zip &>>${LOG_FILE}
StatusCheck $?

mv payment-main payment
cd /home/roboshop/payment

echo "Installing dependencies"
pip3 install --user -r requirements.txt

#Update the roboshop user and group id payment.ini file.
#Update SystemD service file
#Update `CARTHOST` with cart server ip
#Update `USERHOST` with user server ip

#Update `AMQPHOST` with RabbitMQ server ip.

# mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
# systemctl daemon-reload
# systemctl enable payment
# systemctl start payment