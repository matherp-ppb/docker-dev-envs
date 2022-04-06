#Assumes USER & HOME are in the env by linuxy default and that
#ALPINE_VERSION, GLIBC_VERSION & AWS_CDK_VERSION are from...
include ./ALPINE_VERSION
include ./AWS_CDK_VERSION
include ./GLIBC_VERSION

DOCKER_ID=$(USER)ppb
IMAGE_NAME ?= alpine-gh-aws2-cdk$(AWS_CDK_VERSION)
IMAGE_NAME_HEX = $(shell echo "{\"containerName\":\"/$(IMAGE_NAME)\"}" | od -A n -t x1 | tr -d '[\n\t ]')
TAG = $(AWS_CDK_VERSION)

.PHONY: check list

list:
	@echo "build	- Import *_VERSION files & build the Docker container as per the Dockerfile."
	@echo "scan	- Scan the container with snyk for security feedback."
	@echo "test	- Run the container & echo out versions of key components."
	@echo "shell	- Run sh in the container with ~ mapped from outside to inside the container, work dir at /home/$(USER), delete on exit."
	@echo "run	- Run sh as above but leave running after exit."
	@echo "exec	- Exec into the container at /home/${USER}."
	@echo "stop	- Stops the container".
	@echo "rm	- Deletes the container."
	@echo "rmi	- Deletes the image of the container."
	@echo "prune	- Clears up an unattched volumes."
	@echo "clean	- Stop, rm, rmi and prune the containers." 
	@echo "code	- Open VSCode connected to the container in work directory."
	@echo "work	- Run make build, test, run, code & exec to get VSCode connected & exec'ed into a clean dev env." 
	@echo "coffee	- As per work but will run a security scan between build and test stage."
build:
	sudo docker build --build-arg ENV_USER=$(USER) --build-arg ENV_ALPINE_VERSION=$(ALPINE_VERSION) --build-arg ENV_AWS_CDK_VERSION=$(AWS_CDK_VERSION) --build-arg ENV_GLIBC_VERSION=$(GLIBC_VERSION) -t $(DOCKER_ID)/$(IMAGE_NAME) .

scan:
	docker scan $(DOCKER_ID)/$(IMAGE_NAME)

test:
	docker run --rm -it $(DOCKER_ID)/$(IMAGE_NAME) sh -c 'cat /proc/version && printf "CDK: " && cdk --version && aws --version && printf "NPM: " && npm -v && printf "Node: " && node -v'

shell:
	docker run --rm -it -w /home/$(USER) -v $(HOME):/home/$(USER) $(DOCKER_ID)/$(IMAGE_NAME) /bin/sh

run:
	docker run -itd -w /home/$(USER) -v $(HOME)/:/home/$(USER) --name $(IMAGE_NAME) $(DOCKER_ID)/$(IMAGE_NAME) /bin/sh

exec:
	docker exec -it -w /home/$(USER) $(IMAGE_NAME) /bin/sh

code:
	code --folder-uri vscode-remote://attached-container+${IMAGE_NAME_HEX}/home/${USER}

work: build test run code exec

coffee: build scan test run code exec

clean: stop rm rmi prune

stop:
	docker stop $(IMAGE_NAME)

rm: check
	docker rm $(IMAGE_NAME)

rmi: check
	docker rmi $(DOCKER_ID)/$(IMAGE_NAME)

prune:
	docker volume prune

check:
	@printf "Are you sure you want to continue? [y/N] " && read ans && [ $${ans:-N} = y ]

#gitTag:
#	-git tag -d $(TAG)
#	-git push origin :refs/tags/$(TAG)
#	git tag $(TAG)
#	git push origin $(TAG)
