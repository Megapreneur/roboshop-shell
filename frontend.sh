source common.sh
component=frontend


echo -e "${color}Installing Nginx Server${nocolor}"
dnf install nginx -y &>>${log_file}
stat_check $?

echo -e "${color}Removing Old App content${nocolor}"
rm -rf /usr/share/nginx/html/* &>>${log_file}
stat_check $?

echo -e "${color}Downloading Frontend Content${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
stat_check $?

echo -e "${color}Extracting Frontend Content${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/$component.zip &>>${log_file}
stat_check $?
# we need to copy config file
echo -e "${color}Copying Roboshop Configuration File${nocolor}"
cp /root/roboshop-shell/roboshop.conf /etc//nginx/default.d/roboshop.conf &>>${log_file}
stat_check $?

echo -e "${color}Starting Nginx Server${nocolor}"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}
stat_check $?