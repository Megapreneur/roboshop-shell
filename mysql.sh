echo -e "\e[33m Disable MySQL Default Version\e[0m"
dnf module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[33mCopy MySql Repo File\e[0m"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstall MySql Server\e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[33mStart MySql Server\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[33mChange MySql Password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log

