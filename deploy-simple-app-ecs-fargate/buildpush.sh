#!/bin/bash
cd ./app

AccountID="$AccountID"

aws ecr get-login-password --region us-east-1 --profile=test | docker login --username AWS --password-stdin $AccountID.dkr.ecr.us-east-1.amazonaws.com 

docker build -t demo-fargate-registry .

docker tag demo-fargate-registry:latest $AccountID.dkr.ecr.us-east-1.amazonaws.com/demo-fargate-registry:latest

docker push $AccountID.dkr.ecr.us-east-1.amazonaws.com/demo-fargate-registry:latest