 LOG_FILE=/tmp/frntend
 source common.sh
 
 echo Installing Nginx
 yum install nginx -y &>>LOG_FILE
StatusCheck $?

 echo Downloading Nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> /tmp/frontend
 StatusCheck $?

 echo switch directory
 cd /usr/share/nginx/html &>>LOG_FILE

 echo remove previous web content
 rm -rf * &>>LOG_FILE
StatusCheck $?
 echo unzipping files
 unzip /tmp/frontend.zip &>>LOG_FILE
 mv frontend-main/static/* . &>>LOG_FILE
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> /tmp/frontend
StatusCheck $?
 echo Starting Nginx Service
 systemctl enable nginx &>>LOG_FILE
 systemctl restart nginx &>>LOG_FILE
 StatusCheck $?