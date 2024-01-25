echo -e "\e[33mInstall Maven\e[0m"
dnf install maven -y &>>/tmp/roboshop.log
echo -e "\e[33mAdd Application User\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33mCreate Application Directory\e[0m"
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[33mDownloading Application Content\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
echo -e "\e[33mExtract Application Content\e[0m"
cd /app &>>/tmp/roboshop.log
unzip /tmp/shipping.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
echo -e "\e[33mClean Package\e[0m"
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

echo -e "\e[33mSetup Shipping Service\e[0m"
cp /root/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log
echo -e "\e[33mStart Shipping Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable shipping &>>/tmp/roboshop.log
systemctl start shipping &>>/tmp/roboshop.log
echo -e "\e[33mInstall MySql Client\e[0m"
dnf install mysql -y &>>/tmp/roboshop.log
echo -e "\e[33mLoad Schema\e[0m"
mysql -h mysql-dev.lanim.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log
echo -e "\e[33mRestart Shipping Service\e[0m"
systemctl restart shipping &>>/tmp/roboshop.log