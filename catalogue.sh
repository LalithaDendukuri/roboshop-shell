echo -e "\e[36m>>>>>>>>>>> start Catalogue service <<<<<<<\e[0m"


echo -e "\e[36m>>>>>> copy Catalogue service file <<<<<<<\e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>> copy mongo repo file <<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo  > /tmp/roboshop.log

echo -e "\e[36m>>>>>> start Catalogue service <<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>> install noejs <<<<<<<\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>> create application user <<<<<<<\e[0m"
useradd roboshop &>>/tmp/roboshop.log
rm -rf /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>> start Catalogue service <<<<<<<\e[0m"
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>> Extract  application content <<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>> install npm<<<<<<<\e[0m"

npm install &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>> install mongo db <<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log


echo -e "\e[36m>>>>>> Load Catalogue schema <<<<<<<\e[0m"
mongo --host mongodb.dljrobo.online </app/schema/catalogue.js &>>/tmp/roboshop.log

systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>> Restart Catalogue service <<<<<<<\e[0m"
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>> End Catalogue service <<<<<<<\e[0m"