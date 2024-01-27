echo -e "\e[33m Configure YUM Repos from the script provided by vendor.\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log
echo -e "\e[33m Configure YUM Repos for RabbitMQ\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log
echo -e "\e[33m Install RabbitMQ Server\e[0m"
dnf install rabbitmq-server -y &>>/tmp/roboshop.log
echo -e "\e[33m Start RabbitMQ Service\e[0m"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl start rabbitmq-server &>>/tmp/roboshop.log

echo -e "\e[33m Create a user for RabbitMQ Service\e[0m"
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log