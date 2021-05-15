#!/bin/bash

source components/common.sh
OS_PREREQ

Head "Installing Dependency"2
apt install openjdk-8-jdk -y &>>$LOG && apt install maven -y &>>$LOG
stat $?


Head "Downloading the component"
cd /root/
git clone https://github.com/Manmohan506/users.git &>>$LOG && cd users
#rm -rf /etc/systemd/system/users.service



Head "Building the Code"
mvn clean &>>$LOG && mvn clean package &>>$LOG
stat $?
Head "Updating Endpoints"
mv /root/users/systemd.service /etc/systemd/system/users.service
sed -i -e "s/LOGIN_ENDPOINT/login.zsdevops01.site/" /etc/systemd/system/users.service
stat $?
Head "Starting the Service"
systemctl daemon-reload &>>$LOG && systemctl start users && systemctl enable users &>>$LOG
systemctl status users

