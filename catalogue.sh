component=$component
color="${color}"
nocolor=" ${nocolor}"


echo -e "${color}Configuring NodeJS ${nocolor}"
dnf module disable nodejs -y &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log

echo -e "${color}Installing NodeJS ${nocolor}"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "${color}Add Application User ${nocolor}"
useradd roboshop &>>/tmp/roboshop.log

echo -e "${color}Create Application Directory ${nocolor}"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "${color}Downloading Application Content ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log
cd /app

echo -e "${color}Extract Application Content ${nocolor}"
unzip /tmp/$component.zip &>>/tmp/roboshop.log
cd /app

echo -e "${color}Installing NodeJS Dependencies ${nocolor}"
npm install &>>/tmp/roboshop.log

echo -e "${color}Setup SystemD Service ${nocolor}"
cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>/tmp/roboshop.log

echo -e "${color}Start Catalogue Service ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable $component &>>/tmp/roboshop.log
systemctl start $component &>>/tmp/roboshop.log

echo -e "${color}Copy MongoDB Repo File ${nocolor}"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "${color}Install MongoDB Client ${nocolor}"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "${color}Load Schema ${nocolor}"
mongo --host mongodb-dev.lanim.shop </app/schema/$component.js &>>/tmp/roboshop.log