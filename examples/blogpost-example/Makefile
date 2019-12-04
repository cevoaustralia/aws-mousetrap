STACK=blogpost-mousetrap
TEMPLATE=blogpost-example.yml
BUCKET=cmp-proud-refrigerator

all: deploy

deploy: package
	aws cloudformation deploy \
		--stack-name $(STACK) \
		--template-file rendered.yml \
		--capabilities CAPABILITY_IAM \
		--no-fail-on-empty-changeset

package:
	aws cloudformation package \
		--template-file $(TEMPLATE) \
		--s3-bucket $(BUCKET) \
		--output-template-file rendered.yml

clean:
	aws cloudformation delete-stack \
		--stack-name $(STACK) && \
	aws cloudformation wait stack-delete-complete \
		--stack-name $(STACK)

publish: message get-topic-arn
	aws sns publish \
		--topic-arn $(TOPIC_ARN) \
		--message $(MESSAGE)

consume: get-ssm-param
	aws ssm get-parameter \
		--name $(SSM_PARAMETER) \
		--query 'Parameter.Value' \
		--output text

message:
	$(eval MESSAGE := $(shell uuidgen))
	@echo message is $(MESSAGE)

get-topic-arn:
	$(eval TOPIC_ARN := $(shell \
		aws cloudformation describe-stacks \
			--stack-name $(STACK) \
			--query 'Stacks[].Outputs[?OutputKey==`InputArn`].OutputValue' \
			--output text ))
	@echo Topic ARN is $(TOPIC_ARN)

get-ssm-param:
	$(eval SSM_PARAMETER := $(shell \
		aws cloudformation describe-stacks \
			--stack-name $(STACK) \
			--query 'Stacks[].Outputs[?OutputKey==`OutputName`].OutputValue' \
			--output text ))
	@echo SSM parameter is $(SSM_PARAMETER)
