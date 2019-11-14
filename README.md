# devops_fun_assignment

Purpose of this repo deploying serverless application as 2 different Lambda function and ECS Fargate container, exposed with Appliation Load Balancer.

> This repo create 2 lambda functions hello1 and hello2 on AWS and adjust alb as trigger with path-based routing /hello1 and /hello2

1. Write your own function within lambda_functions/{hello1,hello2}/main.py (for now only 2 functions allowed)
2. ECS Fargate services added for default action Application Load Balancer, you can specify your own container in variables.tf
3. Rest of them will be set by Terraform. Follow actions as follow;

```
cd terraform/
make package
make init
make plan
make apply
make destroy
```