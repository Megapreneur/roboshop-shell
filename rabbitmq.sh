source common.sh
component=rabbitmq-server

echo -e "${color} Configure YUM Repos from the script provided by vendor.${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
stat_check $?

echo -e "${color} Configure YUM Repos for RabbitMQ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/$component/script.rpm.sh | bash &>>${log_file}
stat_check $?

echo -e "${color} Install RabbitMQ Server${nocolor}"
dnf install $component -y &>>${log_file}
stat_check $?

echo -e "${color} Start RabbitMQ Service${nocolor}"
systemctl enable $component &>>${log_file}
systemctl start $component &>>${log_file}
stat_check $?

echo -e "${color} Create a user for RabbitMQ Service${nocolor}"
rabbitmqctl add_user roboshop $1 &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
stat_check $?