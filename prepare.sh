#!/bin/sh

#отключаем SELinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

#отключаем firewall.d
systemctl stop firewalld
systemctl disable firewalld

#ставим нужные пакеты
yum install -y net-tools zip unzip mc wget yum-utils telnet epel-release git git-lfs curl
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sed -i 's/$releasever/7/g' /etc/yum.repos.d/docker-ce.repo
yum update
yum install -y docker-ce docker-ce-cli containerd.io

#добавляем docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#создаем каталоги контейнеров
cd /opt
mkdir FE20
cd FE20
mkdir spring && mkdir ./spring/logs && mkdir ./spring/etc && mkdir ./spring/file-exchanger
mkdir react && mkdir ./react/front/ && mkdir ./react/logs
mkdir postgres && mkdir ./postgres/pgdata && mkdir ./postgres/scripts

#скачиваем и распаковываем стартовые скрипты
cd /opt
wget https://github.com/it-uni/files/raw/main/RA.zip
unzip RA.zip

#копируем файлы по папкам
cp -R front/* /opt/FE20/react/front/
cp ROOT.war /opt/FE20/spring/
cp *.sql /opt/FE20/postgres/scripts/
cp *.yml /opt/FE20/
cp Dockerfile_back /opt/FE20/spring/
cp nginx.conf /opt/FE20/react/

#разворачиваем контейнеры
#cd /opt/FE20 && docker-compose up --build -d


