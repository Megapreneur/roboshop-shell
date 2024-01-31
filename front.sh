color="\e[33m"
nocolor="\e[0m"


echo -e "${color}Install Nginx ${nocolor}"
dnf install nginx -y &>>/tmp/roboshop.log
echo -e "${color}Enable Nginx${nocolor}"
systemctl enable nginx &>>/tmp/roboshop.log
echo -e "${color}Starting Nginx${nocolor}"
systemctl start nginx &>>/tmp/roboshop.log
echo -e "${color}Install Nginx${nocolor}"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
echo -e "${color}Downloading Frontend Content${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log
echo -e "${color}Extracting Frontend Content${nocolor}"
cd /usr/share/nginx/html &>>/tmp/roboshop.log
unzip /tmp/frontend.zip &>>/tmp/roboshop.log
echo -e "${color}Copying Roboshop Configuration File${nocolor}"
cp /root/roboshop-shell/roboshop.conf /etc//nginx/default.d/roboshop.conf &>>/tmp/roboshop.log
echo -e "${color}Restart Nginx${nocolor}"
systemctl restart nginx &>>/tmp/roboshop.log