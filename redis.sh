source common.sh

echo -e "\e[33m Install Redis Repos\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log

echo -e "\e[33m Enable Redis 66 Version\e[0m"
dnf module enable redis:remi-6.2 -y &>>/tmp/roboshop.log

echo -e "\e[33m Install Redis\e[0m"
dnf install redis -y &>>/tmp/roboshop.log

echo -e "\e[33m Update Redis Listen address\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>/tmp/roboshop.log

echo -e "\e[33m Start Redis Service\e[0m"
systemctl enable redis &>>/tmp/roboshop.log
systemctl start redis &>>/tmp/roboshop.log