.PHONY: all plan apply destroy

all: help

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'

help:						## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

package:					## Package python code as zip
	zip -j ../lambda_functions/hello1.zip ../lambda_functions/hello1/main.py
	zip -j ../lambda_functions/hello2.zip ../lambda_functions/hello2/main.py
get:				 		## Get the terraform modules
	terraform get

init:						## Initialize remote S3 backend.
	terraform init

fmt:						## Lint/Format the terraform code in canonical format.
	terraform fmt --diff

validate:					## Validate the Terraform files
	terraform validate

plan:						## Plan the changes to infra.
	terraform plan -out terraform.plan

refresh:					## Refresh the remote state with existing AWS infra.
	terraform refresh

apply:						## Apply the changes in plan.
	terraform apply -input=false terraform.plan

output:						## See the output.
	terraform output -json

destroy:					## Destroy the infra. (BE VERY CAREFUL with THIS).
	terraform destroy

#ifndef AWS_PROFILE
#	$(error AWS_PROFILE is not defined. Make sure that you set your AWS profile and region.)
#endif
# verify-aws-profile-set:
# ifndef AWS_DEFAULT_REGION
# 	$(error AWS_DEFAULT_REGION is not defined. Make sure that you set your AWS region.)
# endif