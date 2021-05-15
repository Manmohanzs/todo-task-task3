#!/bin/bash

source components/common.sh
OS_PREREQ

Head "Installing Dependency"
apt install golang -y &>>$LOG
Stat $?

Head "Downloading Component"

cd /todo-task3
rm -rf login
git clone https://github.com/Manmohan506/login.git &>>$LOG && cd login


Head "Building Package"
go build &>>$LOG

Head "Get dependencies"
go get github.com/dgrijalva/jwt-go &>>$LOG && go get github.com/labstack/echo &>>$LOG && go get github.com/labstack/echo/middleware &>>$LOG && go get github.com/labstack/gommon/log &>>$LOG && go get github.com/openzipkin/zipkin-go &>>$LOG && go get github.com/openzipkin/zipkin-go/middleware/http &>>$LOG && go get github.com/openzipkin/zipkin-go/reporter/http &>>$LOG
Stat $?
Head "Again Build"
go build main.go user.go tracing.go &>>$LOG

rm -rf /etc/systemd/system/login.service
mv systemd.service /etc/systemd/system/login.service
sed -i -e "s/USER_ENDPOINT/users.zsdevops01.site/" /etc/systemd/system/login.service

Head "Restarting Services"
systemctl daemon-reload &>>$LOG && systemctl start login && systemctl enable login &>>$LOG
systemctl status login


