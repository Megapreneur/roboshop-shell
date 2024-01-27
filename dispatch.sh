echo -e "\e[33mInstall Golang\e[0m"
dnf install golang -y &>>/tmp/roboshop.log
echo -e "\e[33mAdd Application User\e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33mCreate Application Directory\e[0m"
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[33mDownloading Application Content\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log
echo -e "\e[33mExtract Application Content\e[0m"
cd /app &>>/tmp/roboshop.log
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
echo -e "\e[33mDownload Dependencies\e[0m"
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
echo -e "\e[33mBuild Application\e[0m"
go build &>>/tmp/roboshop.log
echo -e "\e[33mSetup Dispatch Service\e[0m"
cp /root/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log
echo -e "\e[33mStart Dispatch Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl start dispatch &>>/tmp/roboshop.log