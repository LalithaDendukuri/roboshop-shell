component=dispatch
source common.sh
rabbitmq_app_password = $1
if [ -z "$rabbitmq_app_password" ] ; then
  echo " input rabbitmq_app_password is missing"
fi
func_golang

