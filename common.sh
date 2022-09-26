
ID=$(id -u)
if [ $ID -ne 0 ];
then
  echo "you should run this script as a root user or with sudo privileges"
  exit 1
fi

StatusCheck() {
if [ $? -eq 0 ];
then
echo -e status= "\e[32mSUCCESS\e[0m"
else
echo -e status= "\e[31mFAILURE\e[0m"
exit 1
fi
}

APP_PREREQ() {
    id roboshop &>>${LOG_FILE}
    if [ $? -ne 0 ]; then
    echo "Adding roboshop user to the application"
    useradd roboshop &>>${LOG_FILE}
    StatusCheck $?
    fi

    echo "Downloading application code"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
    StatusCheck $?

    cd /home/roboshop

    echo " clear previous files/ app data"
    rm -rf ${COMPONENT}
    StatusCheck $?

    echo "extracting application code"
    unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}
    StatusCheck $?

    mv ${COMPONENT}-main ${COMPONENT}
    cd /home/roboshop/${COMPONENT}
}

SYSTEMD_SETUP() {

echo "Updating IP address in SystemD file"
  sed -i -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
  StatusCheck $?

  echo "${COMPONENT} service setup"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  StatusCheck $?

  systemctl daemon-reload &>>${LOG_FILE}
  systemctl enable ${COMPONENT} &>>${LOG_FILE}


  echo "restarting ${COMPONENT} service"
  systemctl restart ${COMPONENT} &>>${LOG_FILE}
  StatusCheck $?
}

NodeJS() {

  echo "Download NodeJS package"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  StatusCheck $?

  echo "Installing NodeJS package"
  yum install nodejs -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

  echo "Installing NodeJS dependencies"
  npm install &>>${LOG_FILE}
  StatusCheck $?

  SYSTEMD_SETUP
}


