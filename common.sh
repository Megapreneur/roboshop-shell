color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"


nodejs(){
  echo -e "${color}Configuring NodeJS ${nocolor}"
  dnf module disable nodejs -y &>>${log_file}
  dnf module enable nodejs:18 -y &>>${log_file}

  echo -e "${color}Installing NodeJS ${nocolor}"
  dnf install nodejs -y &>>${log_file}

  echo -e "${color}Add Application User ${nocolor}"
  useradd roboshop &>>${log_file}

  echo -e "${color}Create Application Directory ${nocolor}"
  rm -rf ${app_path} &>>${log_file}
  mkdir ${app_path} &>>${log_file}

  echo -e "${color}Downloading Application Content ${nocolor}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
  cd ${app_path}

  echo -e "${color}Extract Application Content ${nocolor}"
  unzip /tmp/$component.zip &>>${log_file}
  cd ${app_path}

  echo -e "${color}Installing NodeJS Dependencies ${nocolor}"
  npm install &>>${log_file}

  echo -e "${color}Setup SystemD Service ${nocolor}"
  cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}

  echo -e "${color}Start Catalogue Service ${nocolor}"
  systemctl daemon-reload &>>${log_file}
  systemctl enable $component &>>${log_file}
  systemctl start $component &>>${log_file}
}
