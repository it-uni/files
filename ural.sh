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
mkdir FE20-URAL
cd FE20-URAL
mkdir spring && mkdir ./spring/logs && mkdir ./spring/etc && mkdir ./spring/file-exchanger && mkdir ./spring/temp
mkdir react && mkdir ./react/front/ && mkdir ./react/logs
mkdir postgres && mkdir ./postgres/pgdata && mkdir ./postgres/scripts

#скачиваем и распаковываем стартовые скрипты
cd /opt/FE20-MMK
wget https://github.com/it-uni/test/raw/main/ural.zip
unzip MMK.zip

#копируем файлы по папкам
cp -R /front/* /opt/FE20-URAL/react/front/
cp ROOT.war /opt/FE20-URAL/spring/
cp *.sql /opt/FE20-URAL/postgres/scripts/
cp *.yml /opt/FE20-URAL/
cp Dockerfile /opt/FE20-URAL/spring/
cp nginx.conf /opt/FE20-URAL/react/
cp /temp/* /opt/FE20-URAL/spring/temp/

#разворачиваем контейнеры
cd /opt/FE20-URAL && docker-compose up --build -d

