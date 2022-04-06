# docker-dev-envs
Currently just a make file that automates building a docker container with CDK, aws cli and some other bits in to use as development environments.
Was trying to make this into a next generation of dev environment for AWS 2.0 with only AWS SSO login working with CDK but currently facing assume role issues that Adrian Taut is looking into.
Asciicinema recording shows how to install aws-azure-login and as /home/$USER/ is mounted into the container your login creds follow you.
Assumes you have docker desktop + vscode setup, clone this repo and then run make to see a list of what commands are available.

Todo
   Why does cdn-dia not work ATM?
   Keep aws-azure-login in
   Remove /root/ mounts now that we use non-root user.

Use the Makefile for shortcuts...
```
10:06:37 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝] on 🅰  (eu-west-1) ✗  make
build   - Import *_VERSION files & build the Docker container as per the Dockerfile .
scan    - Scan the container with snyk for security feedback.
test    - Run the container & echo out versions of key components.
shell   - Run sh in the container with ~ mapped to /root/ + .aws/ and .npmrc, work dir at /home/matherp, delete on exit.
run     - Run sh as above but leave running after exit.
exec    - Exec into the container at /home/matherp.
stop    - Stops the container.
rm      - Deletes the container.
rmi     - Deletes the image of the container.
prune   - Clears up an unattched volumes.
clean   - Stop, rm, rmi and prune the containers.
code    - Open VSCode connected to the container in work directory.
work    - Run make build, test, run, code & exec to get VSCode connected & exec'ed into a clean dev env.
coffee  - As per work but will run a security scan between build and test stage.
```

Rest of demo here...
[![asciicast](https://asciinema.org/a/484866.svg)](https://asciinema.org/a/484866)

If you have not already setup aws sso this is how roughly, you need to be added to the right AD groups which are below the existing ones in AD.

```
➜ aws configure sso --profile tribe-prod-developerAdmin
> aws configure sso --profile tribe-prod-developerAdmin
SSO start URL [None]: https://d-93670ced1d.awsapps.com/start
SSO Region [None]: eu-west-1
There are 5 AWS accounts available to you.
Using the account ID 184009931817
The only role available to you is: tribe-prod-developerAdmin
Using the role name "tribe-prod-developerAdmin"
CLI default client Region [None]: eu-west-1
CLI default output format [None]: json

To use this profile, specify the profile name using --profile, as shown:

aws s3 ls --profile tribe-tooling-developerAdmin

➜ aws configure sso --profile tribe-dev-developerAdmin
> aws configure sso --profile tribe-dev-developerAdmin
SSO start URL [None]: https://d-93670ced1d.awsapps.com/start
SSO Region [None]: eu-west-1
There are 5 AWS accounts available to you.
Using the account ID 069140385617
The only role available to you is: tribe-dev-developerAdmin
Using the role name "tribe-dev-developerAdmin"
CLI default client Region [None]: eu-west-1
CLI default output format [None]: json

To use this profile, specify the profile name using --profile, as shown:

aws s3 ls --profile tribe-dev-developerAdmin

➜ aws configure sso --profile tribe-tooling-developerAdmin
> aws configure sso --profile tribe-tooling-developerAdmin
SSO start URL [None]: https://d-93670ced1d.awsapps.com/start
SSO Region [None]: eu-west-1
There are 5 AWS accounts available to you.
Using the account ID 330941722859
There are 2 roles available to you.
Using the role name "tribe-tooling-developerAdmin"
CLI default client Region [None]: eu-west-1
CLI default output format [None]: json

To use this profile, specify the profile name using --profile, as shown:

aws s3 ls --profile tribe-tooling-developerAdmin
```

## Later
Alpine version not showing in ENVs
https://cli.github.com/manual/gh_release_create
change make gitTag to make tag for both github and docker
add make release that adds tagged docker image to github and releases
Investigate https://app.snyk.io/account
