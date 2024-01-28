source common.sh
component=catalogue

nodejs

echo -e "${color}Copy MongoDB Repo File ${nocolor}"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

echo -e "${color}Install MongoDB Client ${nocolor}"
dnf install mongodb-org-shell -y &>>${log_file}

echo -e "${color}Load Schema ${nocolor}"
mongo --host mongodb-dev.lanim.shop </app/schema/$component.js &>>${log_file}