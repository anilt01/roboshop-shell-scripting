 echo Installing Nginx
 yum install nginx -y

 echo Downloading Nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

 echo switch directory
 cd /usr/share/nginx/html

 echo remove previous web content
 rm -rf *

 echo unzipping files
 unzip /tmp/frontend.zip
 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

 echo Starting Nginx Service
 systemctl enable nginx
 systemctl restart nginx