color="\e[34m"
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
  if [ $1 -eq 0 ]; then
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

  app_presetup

  echo -e "${color}Installing NodeJS Dependencies ${nocolor}"
  npm install &>>${log_file}
  stat_check $?

  systemd_setup


}
app_presetup(){
  echo -e "${color}Add Application User ${nocolor}"
    add_user
    stat_check $?

    echo -e "${color}Create Application Directory ${nocolor}"
    rm -rf ${app_path} &>>${log_file}
    mkdir ${app_path} &>>${log_file}
    stat_check $?

    echo -e "${color}Downloading Application Content ${nocolor}"
    curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${log_file}
    stat_check $?

    echo -e "${color}Extract Application Content ${nocolor}"
    cd ${app_path}
    unzip /tmp/$component.zip &>>${log_file}
    stat_check $?
}
mongo_schema_setup(){
  echo -e "${color}Copy MongoDB Repo File ${nocolor}"
  cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
  stat_check $?

  echo -e "${color}Install MongoDB Client ${nocolor}"
  dnf install mongodb-org-shell -y &>>${log_file}
  stat_check $?

  echo -e "${color}Load Schema ${nocolor}"
  mongo --host mongodb-dev.lanim.shop <${app_path}/schema/$component.js &>>${log_file}
  stat_check $?
}

systemd_setup() {
  echo -e "${color} Setup SystemD Service  ${nocolor}"
  cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>${log_file}
  sed -i -e "s/roboshop_app_password/$roboshop_app_password/"  /etc/systemd/system/$component.service
  stat_check $?

  echo -e "${color} Start $component Service ${nocolor}"
  systemctl daemon-reload  &>>${log_file}
  systemctl enable $component  &>>${log_file}
  systemctl restart $component  &>>${log_file}
  stat_check $?
}
python(){
  echo -e "${color}Install Python ${nocolor}"
  dnf install python36 gcc python3-devel -y &>>${log_file}
  stat_check $?

  app_presetup

  echo -e "${color}Download Dependencies${nocolor}"
  pip3.6 install -r requirements.txt &>>${log_file}
  stat_check $?

  systemd_setup
}
mysql_schema_setup(){
  echo -e "${color}Install MySql Client${nocolor}"
  dnf install mysql -y &>>${log_file}
  stat_check $?
  echo -e "${color}Load Schema${nocolor}"
  mysql -h mysql-dev.lanim.shop -uroot -p${mysql_root_password} </app/schema/shipping.sql &>>${log_file}
  stat_check $?
}

maven(){
    echo -e "${color} Install Maven ${nocolor}"
    yum install maven -y  &>>${log_file}
    stat_check $?

    app_presetup

    echo -e "${color} Download Maven Dependencies ${nocolor}"
    mvn clean package  &>>${log_file}
    mv target/${component}-1.0.jar ${component}.jar  &>>${log_file}
    stat_check $?

    mysql_schema_setup
    systemd_setup

}
