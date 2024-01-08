
dnf module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[33mCopy MongoDB Repo File\e[0m"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log
dnf install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[33mStart MongoDB Server\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[33mChange Mysql Password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log

