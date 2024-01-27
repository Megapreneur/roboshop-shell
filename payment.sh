
echo -e "\e[33mInstall Python 3.6\e[0m"
dnf install python36 gcc python3-devel -y
echo -e "\e[33mAdd Application User\e[0m"
useradd roboshop
echo -e "\e[33mCreate Application Directory\e[0m"
mkdir /app
echo -e "\e[33mDownloading Application Content\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
echo -e "\e[33mExtract Application Content\e[0m"
cd /app
unzip /tmp/payment.zip
cd /app
echo -e "\e[33mDownload Dependencies\e[0m"
pip3.6 install -r requirements.txt
echo -e "\e[33mSetup Payment Service\e[0m"
cp /root/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log
echo -e "\e[33mStart Payment Service\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl start payment