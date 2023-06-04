#!/bin/bash

#This script needs to install aws-cli and retreive secret
#tested on canonical Ubuntu

sudo snap install aws-cli --classic
aws secretsmanager get-secret-value --secret-id adminDB_creds --region eu-north-1 --output json > /tmp/credentials.env