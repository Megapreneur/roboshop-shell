source common.sh
component=payment


echo -e "${color}Install Python ${nocolor}"
dnf install python36 gcc python3-devel -y &>>${log_file}
stat_check $?

echo -e "${color}Add Application User${nocolor}"
add_user $?
stat_check $?


echo -e "${color}Create Application Directory${nocolor}"
mkdir /app &>>${log_file}
stat_check $?

echo -e "${color}Downloading Application Content${nocolor}"
curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
stat_check $?

echo -e "${color}Extract Application Content${nocolor}"
cd /app
unzip /tmp/$component.zip &>>${log_file}
cd /app &>>${log_file}
stat_check $?

echo -e "${color}Download Dependencies${nocolor}"
pip3.6 install -r requirements.txt &>>${log_file}
stat_check $?

echo -e "${color}Setup Payment Service${nocolor}"
cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}
stat_check $?

echo -e "${color}Start Payment Service${nocolor}"
systemctl daemon-reload &>>${log_file}
systemctl enable $component &>>${log_file}
systemctl start $component &>>${log_file}
stat_check $?