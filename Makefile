STACK=pkdcloud-mousetrap
TEMPLATE=mousetrap.yml
BUCKET=pkdcloud-mousetrap

all: deploy

deploy: s3 package
	aws cloudformation deploy \
		--stack-name $(STACK) \
		--template-file rendered.yml \
		--capabilities CAPABILITY_IAM \
		--no-fail-on-empty-changeset

s3: 
	aws s3 mb \
		s3://$(BUCKET) 

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
	aws s3 rb \
		s3://$(BUCKET) --force

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
