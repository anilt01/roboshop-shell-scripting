 echo Installing Nginx
 yum install nginx -y &>> /tmp/frontend.sh

 echo Downloading Nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> /tmp/frontend.sh

 echo switch directory
 cd /usr/share/nginx/html &>> /tmp/frontend.sh

 echo remove previous web content
 rm -rf * &>> /tmp/frontend.sh

 echo unzipping files
 unzip /tmp/frontend.zip &>> /tmp/frontend.sh
 mv frontend-main/static/* . &>> /tmp/frontend.sh
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> /tmp/frontend.sh

 echo Starting Nginx Service
 systemctl enable nginx &>> /tmp/frontend.sh
 systemctl restart nginx &>> /tmp/frontend.sh