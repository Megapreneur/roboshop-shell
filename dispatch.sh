source common.sh
component=dispatch

echo -e "${color}Install Golang${nocolor}"
dnf install golang -y &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Add Application User${nocolor}"
useradd roboshop &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Create Application Directory${nocolor}"
mkdir ${app_path} &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Downloading Application Content${nocolor}"
curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Extract Application Content${nocolor}"
cd ${app_path} &>>${log_file}
unzip /tmp/$component.zip &>>${log_file}
cd ${app_path} &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Download Dependencies${nocolor}"
go mod init $component &>>${log_file}
go get &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Build Application${nocolor}"
go build &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Setup Dispatch Service${nocolor}"
cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi

echo -e "${color}Start Dispatch Service${nocolor}"
systemctl daemon-reload &>>${log_file}
systemctl enable $component &>>${log_file}
systemctl start $component &>>${log_file}
if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
  fi