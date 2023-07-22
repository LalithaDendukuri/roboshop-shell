cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
##Update listen address
systemctl enable mongod
systemctl restart mongod
