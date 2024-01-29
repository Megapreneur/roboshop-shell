color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"
success="\e[32m"
failure="\e[31m"
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
  echo Script should be running with sudo
  exit 1
fi

stat_check(){
  if [ $? -eq 0 ]; then
      echo -e "${success}SUCCESS${nocolor}"
    else
      echo -e "${failure}FAILURE${nocolor}"
      exit 1
    fi
}
add_user(){
  id roboshop &>>${log_file}
  if [ $? -eq 1 ]; then
    useradd roboshop &>>${log_file}
  fi
}


nodejs(){
  echo -e "${color}Configuring NodeJS ${nocolor}"
  dnf module disable nodejs -y &>>${log_file}
  dnf module enable nodejs:18 -y &>>${log_file}
  stat_check $?

  echo -e "${color}Installing NodeJS ${nocolor}"
  dnf install nodejs -y &>>${log_file}
  stat_check $?

  echo -e "${color}Add Application User ${nocolor}"
  useradd roboshop &>>${log_file}
  stat_check $?

  echo -e "${color}Create Application Directory ${nocolor}"
  rm -rf ${app_path} &>>${log_file}
  mkdir ${app_path} &>>${log_file}
  stat_check $?

  echo -e "${color}Downloading Application Content ${nocolor}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
  cd ${app_path}
  stat_check $?

  echo -e "${color}Extract Application Content ${nocolor}"
  unzip /tmp/$component.zip &>>${log_file}
  cd ${app_path}
  stat_check $?

  echo -e "${color}Installing NodeJS Dependencies ${nocolor}"
  npm install &>>${log_file}
  stat_check $?

  echo -e "${color}Setup SystemD Service ${nocolor}"
  cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}
  stat_check $?

  echo -e "${color}Start Catalogue Service ${nocolor}"
  systemctl daemon-reload &>>${log_file}
  systemctl enable $component &>>${log_file}
  systemctl start $component &>>${log_file}
  stat_check $?
}
