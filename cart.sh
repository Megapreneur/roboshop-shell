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
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[33mExtract Application Content\e[0m"
unzip /tmp/cart.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[33mInstalling NodeJS Dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33mSetup Cart Service\e[0m"
cp /root/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>/tmp/roboshop.log

systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable cart &>>/tmp/roboshop.log
systemctl start cart &>>/tmp/roboshop.log