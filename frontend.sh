 LOG_FILE=/tmp/frontend
 echo Installing Nginx
 yum install nginx -y &>> /tmp/frontend
 echo status = $?

 echo Downloading Nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> /tmp/frontend
 echo status = $?

 echo switch directory
 cd /usr/share/nginx/html &>> /tmp/frontend

 echo remove previous web content
 rm -rf * &>> /tmp/frontend
echo status = $?
 echo unzipping files
 unzip /tmp/frontend.zip &>> /tmp/frontend
 mv frontend-main/static/* . &>> /tmp/frontend
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> /tmp/frontend
echo status = $?
 echo Starting Nginx Service
 systemctl enable nginx &>> /tmp/frontend
 systemctl restart nginx &>> /tmp/frontend
 echo status = $?