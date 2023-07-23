java_node{
log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> start ${component} service <<<<<<<\e[0m"


echo -e "\e[36m>>>>>> copy ${component} service file <<<<<<<\e[0m"

cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

echo -e "\e[36m>>>>>> copy mongo repo file <<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo  > /tmp/roboshop.log

echo -e "\e[36m>>>>>> start ${component} service <<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log}

echo -e "\e[36m>>>>>> install noejs <<<<<<<\e[0m"
yum install nodejs -y &>>${log}

echo -e "\e[36m>>>>>> create application ${component} <<<<<<<\e[0m"
${component}add roboshop &>>${log}
rm -rf /app &>>${log}
echo -e "\e[36m>>>>>> start ${component} service <<<<<<<\e[0m"
mkdir /app &>>${log}
echo -e "\e[36m>>>>>> Extract  application content <<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
cd /app &>>${log}
unzip /tmp/${component}.zip &>>${log}
cd /app &>>${log}
echo -e "\e[36m>>>>>> install npm<<<<<<<\e[0m"

npm install &>>${log}

echo -e "\e[36m>>>>>> install mongo db <<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>${log}


echo -e "\e[36m>>>>>> Load ${component} schema <<<<<<<\e[0m"
mongo --host mongodb.dljrobo.online </app/schema/${component}.js &>>${log}

systemctl daemon-reload &>>${log}

echo -e "\e[36m>>>>>> Restart ${component} service <<<<<<<\e[0m"
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}

echo -e "\e[36m>>>>>> End ${component} service <<<<<<<\e[0m"

}