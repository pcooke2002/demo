#!/bin/bash

rm -rf terraform_project

#!/bin/bash

# Create the main directory structure
mkdir -p terraform_project/modules/{apigateway,cloudwatch,dynamodb,lambda,lambda_iam,lambda_layer,sns}
mkdir -p terraform_project/modules/lambda/lambda_function
# Create the required files
touch terraform_project/main.tf
touch terraform_project/outputs.tf
touch terraform_project/variables.tf

# Create the module files
touch terraform_project/modules/apigateway/apigateway.tf
touch terraform_project/modules/apigateway/outputs.tf
touch terraform_project/modules/apigateway/variables.tf

touch terraform_project/modules/cloudwatch/log_group.tf
touch terraform_project/modules/cloudwatch/metric_alarm.tf
touch terraform_project/modules/cloudwatch/outputs.tf
touch terraform_project/modules/cloudwatch/variables.tf

touch terraform_project/modules/dynamodb/dynamodb.tf
touch terraform_project/modules/dynamodb/outputs.tf
touch terraform_project/modules/dynamodb/variables.tf

touch terraform_project/modules/lambda/function.tf
touch terraform_project/modules/lambda/lambda_function/lambda_function.py
touch terraform_project/modules/lambda/outputs.tf
touch terraform_project/modules/lambda/variables.tf

touch terraform_project/modules/lambda_iam/iam.tf
touch terraform_project/modules/lambda_iam/outputs.tf
touch terraform_project/modules/lambda_iam/variables.tf

touch terraform_project/modules/lambda_layer/layer.tf
touch terraform_project/modules/lambda_layer/outputs.tf
touch terraform_project/modules/lambda_layer/variables.tf

touch terraform_project/modules/sns/sns.tf
touch terraform_project/modules/sns/outputs.tf
touch terraform_project/modules/sns/variables.tf

cd lambda_layer
mkdir /python
python3.12 -m venv venv
source venv/bin/activate
pip install aws-xray-sdk aws-embedded-metrics -t python
deactivate
zip -r xray-sdk.zip ./python
cp xray-sdk.zip ../terraform_project/modules/lambda_layer/xray-sdk.zip
rm -rf venv python/
cd ..