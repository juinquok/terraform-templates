# Terraform Templates
<img alt="Terraform" src="https://img.shields.io/static/v1?label=Built%20for&message=Terraform&color=7B42BC&style=for-the-badge&logo=terraform" height="25"/><br>
<img alt="Terraform" src="https://img.shields.io/static/v1?label=Made%20with&message=VSCode&color=007ACC&style=for-the-badge&logo=visualstudiocode" height="25"/><br><br>
Hi there 👋 This repository contains some terraform templates that I have worked on in the past that deploy resources in the AWS cloud. Feel free to use them or create a PR to contribute to this repository. As with all templates in this repository, they might not be updated to work with the latest version of AWS's resources, please check before deploying them.<br><br>

## API Gateway

### API Gateway with S3 Integration (API-GATEWAY-S3)
This template deploys an API Gateway which allows for files to be uploaded to a S3 bucket via a PUT request. Once deployed the file can be uploaded by making a PUT request to API Gateway's URL eg, "https://API_GATEWAY_URL/file_upload/some_file.txt". In this case, the file will be uploaded to the S3 bucket with the filename of some_file.txt. There is no API key or security for this gateway, do consider that before deploying this. For more information on the integration between S3 and API Gateway, check [here](https://docs.aws.amazon.com/apigateway/latest/developerguide/integrating-api-with-aws-services-s3.html)<br><br>

### API Gateway with SQS Integration
Coming Soon...<br><br>

## Elastic Container Service

### ECS Fargate 
Coming Soon...<br>

