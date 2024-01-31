echo -e "\e[31mInstall Nginx\e[0m"
dnf install nginx -y &>>/tmp/roboshop.log
echo -e "\e[31mEnable Nginx\e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
echo -e "\e[31mStarting Nginx\e[0m"
systemctl start nginx &>>/tmp/roboshop.log
echo -e "\e[31mInstall Nginx\e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
echo -e "\e[31mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log
echo -e "\e[31mExtracting Frontend Content\e[0m"
cd /usr/share/nginx/html &>>/tmp/roboshop.log
unzip /tmp/frontend.zip &>>/tmp/roboshop.log
echo -e "\e[31mCopying Roboshop Configuration File\e[0m"
cp /root/roboshop-shell/roboshop.conf /etc//nginx/default.d/roboshop.conf &>>/tmp/roboshop.log
echo -e "\e[31mRestart Nginx\e[0m"
systemctl restart nginx &>>/tmp/roboshop.log