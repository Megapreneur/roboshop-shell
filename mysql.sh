source common.sh
component=mysql

echo -e "${color} Disable MySQL Default Version${nocolor}"
dnf module disable mysql -y &>>${log_file}
stat_check $?

echo -e "${color}Copy MySql Repo File${nocolor}"
cp /root/roboshop-shell/$component.repo /etc/yum.repos.d/$component.repo &>>${log_file}
stat_check $?

echo -e "${color}Install MySql Server${nocolor}"
yum install mysql-community-server -y &>>${log_file}
stat_check $?

echo -e "${color}Start MySql Server${nocolor}"
systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}
stat_check $?

echo -e "${color}Change MySql Password${nocolor}"
mysql_secure_installation --set-root-pass $1 &>>${log_file}
stat_check $?

