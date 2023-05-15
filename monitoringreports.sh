#!/bin/bash

#USER INPUT version and credentials
echo -n Artifacts version: 
read varname
echo -n Artifactory username: 
read user
echo -n Artifactory password: 
stty -echo
read password
stty echo

#downloading the file
mkdir tempfolder
cp dockerfile tempfolder
cd tempfolder
wget --auth-no-challenge --http-user=$user --http-password=$password https://artifactory.mingle.awsdev.infor.com/artifactory/libs-staging-local/com/infor/security/monitoring/monitoring-reports-cloud-webapp/$varname/monitoring-reports-cloud-webapp-$varname.war

#renaming the file
mv /home/local/Documents/AudMon/monitoringreports/tempfolder/monitoring-reports-cloud-webapp-$varname.war /home/local/Documents/AudMon/monitoringreports/tempfolder/MonitoringReports.war

#DOCKER PROCESS
aws ecr get-login --region us-east-1 > cred.sh
bash cred.sh
docker build -t phma-dev-monitoringreports .
docker tag phma-dev-monitoringreports:latest 957852833411.dkr.ecr.us-east-1.amazonaws.com/phma-dev-monitoringreports:latest  
docker push 957852833411.dkr.ecr.us-east-1.amazonaws.com/phma-dev-monitoringreports:latest

#delete the file
cd ..
sudo rm -r tempfolder/