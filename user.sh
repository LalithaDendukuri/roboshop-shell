cp user.service /etc/systemd/system/service.sh
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

mkdir /app
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
npm install


yum install mongodb-org-shell -y

mongo --host mongodb.dljrobo.onlie </app/schema/user.js

systemctl daemon-reload

systemctl enable user
systemctl start user