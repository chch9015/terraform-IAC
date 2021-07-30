#!/bin/bash
cd /opt/
#install java rpm package with jdk 8
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
#unpack rpm package
rpm -ivh jdk-8u131-linux-x64.rpm
#install tomcat
wget https://mirrors.estointernet.in/apache/tomcat/tomcat-9/v9.0.50/bin/apache-tomcat-9.0.50-windows-x64.zip
#unzip the package
unzip apache-tomcat-9.0.50-windows-x64.zip
#rename
mv apache-tomcat-9.0.50 tomcat
#change the permissions
chmod -R 700 tomcat
#start the service
cd /opt/tomcat/bin
#start the service
./startup.sh

