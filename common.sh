func_apppreq(){
echo -e "\e[36m>>>>>> copy ${component} service file <<<<<<<\e[0m"
cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

echo -e "\e[36m>>>>>> create application user <<<<<<<\e[0m"
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>> cleanup existing application content<<<<<<<\e[0m"
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>> create Application directory <<<<<<<\e[0m"
mkdir /app &>>${log}

echo -e "\e[36m>>>>>> Download  application content <<<<<<<\e[0m"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

echo -e "\e[36m>>>>>> Extract  application content <<<<<<<\e[0m"
cd /app &>>${log}
unzip /tmp/${component}.zip &>>${log}
cd /app
}
func_systemd(){

systemctl daemon-reload
systemctl enable ${component}
systemctl start ${component}

}

func_nodejs(){
log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> start ${component} service <<<<<<<\e[0m"

echo -e "\e[36m>>>>>> create mongodb repo file <<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo  > /tmp/roboshop.log

echo -e "\e[36m>>>>>> install nodejs Repos <<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log}

echo -e "\e[36m>>>>>> install nodejs <<<<<<<\e[0m"
yum install nodejs -y &>>${log}

func_apppreq

echo -e "\e[36m>>>>>> install nodejs(npm) install<<<<<<<\e[0m"
npm install &>>${log}

echo -e "\e[36m>>>>>> install mongo client  <<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>> Load ${component} schema <<<<<<<\e[0m"
mongo --host mongodb.dljrobo.online </app/schema/${component}.js &>>${log}

func_systemd

echo -e "\e[36m>>>>>> End ${component} service <<<<<<<\e[0m"

}

func_java(){
echo -e "\e[36m>>>>>>>>>>>Install maven<<<<<<<\e[0m"
yum install maven -y
func_apppreq

echo -e "\e[36m>>>>>>>>>>>build package<<<<<<<\e[0m"
mvn clean package
mv target/${component}-1.0.jar ${component}.jar

echo -e "\e[36m>>>>>>>>>>>install mySql<<<<<<<\e[0m"
yum install mysql -y


echo -e "\e[36m>>>>>>>>>>>Load schema<<<<<<<\e[0m"
mysql -h mysql.dljrobo.online -uroot -pRoboShop@1 < /app/schema/${component}.sql

}

func_python(){
  func_apppreq
  yum install python36 gcc python3-devel -y

  pip3.6 install -r requirements.txt

  func_systemd
}