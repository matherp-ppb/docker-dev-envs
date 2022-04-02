# docker-dev-envs
Set of docker containers to use as development environments

Clone this repo and then...

```
aws sso login --no-browser
Browser will not be automatically opened.
Please visit the following URL:

https://device.sso.eu-west-1.amazonaws.com/

Then enter the code:

XXXX-XXXX

Alternatively, you may visit the following URL which will autofill the code upon loading:
https://device.sso.eu-west-1.amazonaws.com/?user_code=XXXX-XXXX
Successfully logged into Start URL: https://d-93670ced1d.awsapps.com/start
/opt/app # aws sts get-caller-identity
> aws sts get-caller-identity
{
    "UserId": "AROA5GJT5SJ7XPAABPOE6:philip.mather@paddypowerbetfair.com",
    "Account": "906883863167",
    "Arn": "arn:aws:sts::906883863167:assumed-role/AWSReservedSSO_InfraAdmin_ddf68f2f2ef15701/philip.mather@paddypowerbetfair.com"
}
```

Use the Makefile for shortcuts...
```
make build
sudo docker build --build-arg ENV_ALPINE_VERSION=3.13 --build-arg ENV_AWS_CDK_VERSION=1.91.0 --build-arg ENV_GLIBC_VERSION=2.31-r0 -t matherpppb/alpine-gh-aws2-cdk1.91.0 .
Password:
[+] Building 0.1s (8/8) FINISHED
...
 => => naming to docker.io/matherpppb/alpine-gh-aws2-cdk1.91.0                                0.0s

23:20:11 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝🤷] on 🅰 (eu-west-1) ➜ make scan
docker scan matherpppb/alpine-gh-aws2-cdk1.91.0

Testing matherpppb/alpine-gh-aws2-cdk1.91.0...

Package manager:   apk
Project name:      docker-image|matherpppb/alpine-gh-aws2-cdk1.91.0
Docker image:      matherpppb/alpine-gh-aws2-cdk1.91.0
Platform:          linux/amd64
Base image:        alpine:3.13.9

✔ Tested 51 dependencies for known vulnerabilities, no vulnerable paths found.

According to our scan, you are currently using the most secure version of the selected base image

For more free scans that keep your images secure, sign up to Snyk at https://dockr.ly/3ePqVcp

23:25:15 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝🤷] on 🅰 (eu-west-1) ➜ make test
docker run --rm -it matherpppb/alpine-gh-aws2-cdk1.91.0 sh -c 'cat /proc/version && printf "CDK " && cdk --version && aws --version'
Linux version 5.10.104-linuxkit (root@buildkitsandbox) (gcc (Alpine 10.2.1_pre1) 10.2.1 20201203, GNU ld (GNU Binutils) 2.35.2) #1 SMP Wed Mar 9 19:05:23 UTC 2022
CDK 1.91.0 (build 0f728ce)
aws-cli/2.5.2 Python/3.9.11 Linux/5.10.104-linuxkit exe/x86_64.alpine.3 prompt/off

23:25:19 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝🤷] on 🅰 (eu-west-1) ➜ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

23:25:26 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝🤷] on 🅰 (eu-west-1) ➜ make shell
docker run --rm -it -w /home/matherp -v ~/.aws:/root/.aws -v /Users/matherp:/home/ matherpppb/alpine-gh-aws2-cdk1.91.0 /bin/sh
/home/matherp # cat /proc/version && printf "CDK " && cdk --version && aws --version
Linux version 5.10.104-linuxkit (root@buildkitsandbox) (gcc (Alpine 10.2.1_pre1) 10.2.1 20201203, GNU ld (GNU Binutils) 2.35.2) #1 SMP Wed Mar 9 19:05:23 UTC 2022
CDK 1.91.0 (build 0f728ce)
aws-cli/2.5.2 Python/3.9.11 Linux/5.10.104-linuxkit exe/x86_64.alpine.3 prompt/off
/home/matherp # ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 /bin/sh
   23 root      0:00 ps aux
/home/matherp #

23:25:55 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝🤷] on 🅰 (eu-west-1) ➜ make run
docker run -itd -w /home/matherp -v ~/.aws/:/root/.aws -v /Users/matherp/:/home/ --name alpine-gh-aws2-cdk1.91.0 matherpppb/alpine-gh-aws2-cdk1.91.0 /bin/sh
12417601fb7fbc3e560e4c5aac3f33202b0fa40a0c49bb9e47b4a6173ade3a9c

23:26:07 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝🤷] on 🅰 (eu-west-1) ➜ make exec
docker exec -it -w /home/ alpine-gh-aws2-cdk1.91.0 /bin/sh
/home # cat /proc/version && printf "CDK " && cdk --version && aws --version
Linux version 5.10.104-linuxkit (root@buildkitsandbox) (gcc (Alpine 10.2.1_pre1) 10.2.1 20201203, GNU ld (GNU Binutils) 2.35.2) #1 SMP Wed Mar 9 19:05:23 UTC 2022
CDK 1.91.0 (build 0f728ce)
aws-cli/2.5.2 Python/3.9.11 Linux/5.10.104-linuxkit exe/x86_64.alpine.3 prompt/off
/home # aws sso login --no-browser
> aws sso login --no-browser
Browser will not be automatically opened.
Please visit the following URL:

https://device.sso.eu-west-1.amazonaws.com/

Then enter the code:

XXXX-XXXX

Alternatively, you may visit the following URL which will autofill the code upon loading:
https://device.sso.eu-west-1.amazonaws.com/?user_code=GBHG-BRDF
Successfully logged into Start URL: https://d-93670ced1d.awsapps.com/start
/home # aws sts get-caller-identity
> aws sts get-caller-identity
{
    "UserId": "AROA5GJT5SJ7XPAABPOE6:philip.mather@paddypowerbetfair.com",
    "Account": "906883863167",
    "Arn": "arn:aws:sts::906883863167:assumed-role/AWSReservedSSO_InfraAdmin_ddf68f2f2ef15701/philip.mather@paddypowerbetfair.com"
}
/home #

23:27:32 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[📝🤷] on 🅰 (eu-west-1) ➜ make gitTag
git tag -d 1.91.0
Deleted tag '1.91.0' (was c10f2b8)
git push origin :refs/tags/1.91.0
To github.com:matherp-ppb/docker-dev-envs.git
 - [deleted]         1.91.0
git tag 1.91.0
git push origin 1.91.0
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To github.com:matherp-ppb/docker-dev-envs.git
 * [new tag]         1.91.0 -> 1.91.0
```

## Later
Investigate https://app.snyk.io/account
