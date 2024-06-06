#!/bin/bash
cd ./app

AccountID="$AccountID"

aws ecr get-login-password --region us-east-1 --profile=test | docker login --username AWS --password-stdin $AccountID.dkr.ecr.us-east-1.amazonaws.com 

docker build -t nginxdemo .

docker tag demonginx:latest $AccountID.dkr.ecr.us-east-1.amazonaws.com/demonginx:latest

docker push $AccountID.dkr.ecr.us-east-1.amazonaws.com/demonginx:latest

