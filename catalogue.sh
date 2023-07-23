log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> start Catalogue service <<<<<<<\e[0m"


echo -e "\e[36m>>>>>> copy Catalogue service file <<<<<<<\e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service &>>{$log}

echo -e "\e[36m>>>>>> copy mongo repo file <<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo  > /tmp/roboshop.log

echo -e "\e[36m>>>>>> start Catalogue service <<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>{$log}

echo -e "\e[36m>>>>>> install noejs <<<<<<<\e[0m"
yum install nodejs -y &>>{$log}

echo -e "\e[36m>>>>>> create application user <<<<<<<\e[0m"
useradd roboshop &>>{$log}
rm -rf /app &>>{$log}
echo -e "\e[36m>>>>>> start Catalogue service <<<<<<<\e[0m"
mkdir /app &>>{$log}
echo -e "\e[36m>>>>>> Extract  application content <<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{$log}
cd /app &>>{$log}
unzip /tmp/catalogue.zip &>>{$log}
cd /app &>>{$log}
echo -e "\e[36m>>>>>> install npm<<<<<<<\e[0m"

npm install &>>{$log}

echo -e "\e[36m>>>>>> install mongo db <<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>{$log}


echo -e "\e[36m>>>>>> Load Catalogue schema <<<<<<<\e[0m"
mongo --host mongodb.dljrobo.online </app/schema/catalogue.js &>>{$log}

systemctl daemon-reload &>>{$log}

echo -e "\e[36m>>>>>> Restart Catalogue service <<<<<<<\e[0m"
systemctl enable catalogue &>>{$log}
systemctl restart catalogue &>>{$log}

echo -e "\e[36m>>>>>> End Catalogue service <<<<<<<\e[0m"