# Assumes USER & HOME are in the env by linuxy default and that
# ALPINE_VERSION, GLIBC_VERSION & AWS_CDK_VERSION are from...
include ./ALPINE_VERSION
include ./AWS_CDK_VERSION
include ./GLIBC_VERSION

DOCKER_ID=$(USER)ppb
IMAGE_NAME ?= alpine-gh-aws2-cdk$(AWS_CDK_VERSION)
TAG = $(AWS_CDK_VERSION)

.PHONY: list
list:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

build:
	sudo docker build --build-arg ENV_ALPINE_VERSION=$(ALPINE_VERSION) --build-arg ENV_AWS_CDK_VERSION=$(AWS_CDK_VERSION) --build-arg ENV_GLIBC_VERSION=$(GLIBC_VERSION) -t $(DOCKER_ID)/$(IMAGE_NAME) .

scan:
	docker scan $(DOCKER_ID)/$(IMAGE_NAME)

test:
	docker run --rm -it $(DOCKER_ID)/$(IMAGE_NAME) sh -c 'cat /proc/version && printf "CDK " && cdk --version && aws --version'

shell:
	docker run --rm -it -w /home/$(USER) -v ~/.aws:/root/.aws -v $(HOME):/home/$(USERNAME) $(DOCKER_ID)/$(IMAGE_NAME) /bin/sh

run:
	docker run -itd -w /home/$(USER) -v ~/.aws/:/root/.aws -v $(HOME)/:/home/$(USERNAME) --name $(IMAGE_NAME) $(DOCKER_ID)/$(IMAGE_NAME) /bin/sh

exec:
	docker exec -it -w /home/$(USERNAME) $(IMAGE_NAME) /bin/sh

gitTag:
	-git tag -d $(TAG)
	-git push origin :refs/tags/$(TAG)
	git tag $(TAG)
	git push origin $(TAG)
