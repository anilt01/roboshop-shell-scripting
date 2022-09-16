 LOG_FILE=/tmp/frntend
 echo Installing Nginx
 yum install nginx -y &>>/tmp/frntend
 echo status=$?

 echo Downloading Nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> /tmp/frontend
 echo status=$?

 echo switch directory
 cd /usr/share/nginx/html &>>/tmp/frntend

 echo remove previous web content
 rm -rf * &>>/tmp/frntend
echo status=$?
 echo unzipping files
 unzip /tmp/frontend.zip &>>/tmp/frntend
 mv frontend-main/static/* . &>>/tmp/frntend
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> /tmp/frontend
echo status=$?
 echo Starting Nginx Service
 systemctl enable nginx &>>/tmp/frntend
 systemctl restart nginx &>>/tmp/frntend
 echo status=$?