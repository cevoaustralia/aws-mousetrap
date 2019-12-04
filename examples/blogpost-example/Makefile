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

