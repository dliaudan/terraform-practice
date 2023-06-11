#!/bin/bash

#This script needs to install aws-cli, retreive secret and install CWagent and sent memory usage metrics to CW.
#tested on canonical Ubuntu

sudo snap install aws-cli --classic
aws secretsmanager get-secret-value --secret-id secret_password_test --region eu-north-1 --output json > /tmp/credentials.env

wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
sudo su
sudo echo "{
   \"metrics\":{
      \"metrics_collected\":{
         \"mem\":{
            \"measurement\":[
               \"mem_used_percent\"
            ],
            \"metrics_collection_interval\":60
         }
      },
      \"append_dimensions\": {
        \"InstanceId\": \"\${aws:InstanceId}\"
      }
   }
}" > /opt/aws/amazon-cloudwatch-agent/bin/config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
