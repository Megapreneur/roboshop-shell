echo -e "\e[33mConfiguring NodeJS\e[0m"
dnf module disable nodejs -y &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log

echo -e "\e[33mInstalling NodeJS\e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd Application User\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreate Application Directory\e[0m"
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33mDownloading Application Content\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[33mExtract Application Content\e[0m"
unzip /tmp/user.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[33mInstalling NodeJS Dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33mSetup User Service\e[0m"
cp /root/roboshop-shell/user.service /etc/systemd/system/user.service &>>/tmp/roboshop.log

echo -e "\e[33mStart User Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable user &>>/tmp/roboshop.log
systemctl start user &>>/tmp/roboshop.log

echo -e "\e[33mInstall MongoDB Client\e[0m"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[33mLoad Schema\e[0m"
mongo --host mongodb-dev.lanim.shop </app/schema/user.js &>>/tmp/roboshop.log