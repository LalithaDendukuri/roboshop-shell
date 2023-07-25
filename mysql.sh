mysql_pwd=$1
if [ -z  "$mysql_pwd"]; then
  echo INput Password Missing
fi
cp mysql.repo  /etc/yum.repos.d/mysql.repo

yum module disable mysql -y

yum install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld

mysql_secure_installation --set-root-pass ${mysql_pwd}

mysql -uroot -pRoboShop@1