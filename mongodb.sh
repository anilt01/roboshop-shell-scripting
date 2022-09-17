LOG_FILE=/tmp/mogodb
echo "Downloading mogodb repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo status =$?

echo "Installing Mongodb package"
yum install -y mongodb-org &>>$LOG_FILE
echo status =$?

echo "Updating Listen address in .conf file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status =$?

echo "Enabling MOngodb service"
systemctl enable mongod &>>$LOG_FILE
echo status =$?

echo "Restarting MOngodb Server"
systemctl restart mongod &>>$LOG_FILE
echo status =$?
