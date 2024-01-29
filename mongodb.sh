## Copy repo

source common.sh
component=mongod

echo -e "${color}Copy MongoDB Repo File${nocolor}"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
stat_check $?
echo -e "${color}Installing MongoDB Server${nocolor}"
yum install mongodb-org -y &>>${log_file}
stat_check $?
## Modify the config file
echo -e "${color}Update MongoDB Listen Address${nocolor}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/$component.conf &>>${log_file}
stat_check $?
echo -e "${color}Start MongoDB Server${nocolor}"
systemctl enable $component &>>${log_file}
systemctl restart $component &>>${log_file}
stat_check $?