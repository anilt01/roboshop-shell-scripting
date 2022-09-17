 LOG_FILE=/tmp/frntend
 echo Installing Nginx
 yum install nginx -y &>>LOG_FILE
echo status=$?

 echo Downloading Nginx web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> /tmp/frontend
 echo status=$?

 echo switch directory
 cd /usr/share/nginx/html &>>LOG_FILE

 echo remove previous web content
 rm -rf * &>>LOG_FILE
echo status=$?
 echo unzipping files
 unzip /tmp/frontend.zip &>>LOG_FILE
 mv frontend-main/static/* . &>>LOG_FILE
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>> /tmp/frontend
echo status=$?
 echo Starting Nginx Service
 systemctl enable nginx &>>LOG_FILE
 systemctl restart nginx &>>LOG_FILE
 echo status=$?