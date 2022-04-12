# docker-dev-envs
Currently just a make file that automates building a docker container with CDK, aws cli and some other bits in to use as development environments.
Was trying to make this into a next generation of dev environment for AWS 2.0 with only AWS SSO login working with CDK but currently facing assume role issues that Adrian Taut is looking into.
Asciicinema recording shows how to install aws-azure-login and as /home/$USER/ is mounted into the container your login creds follow you.
Assumes you have docker desktop + vscode setup, clone this repo and then run make to see a list of what commands are available.

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

If you have not already setup aws sso this is how, you need to be added to the right AD groups which are below the existing ones in AD.

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

This is how I've combined it with my AWS Azure SSO details as well...
```
# Current state, I keep aws and azure SSO config seperately and cat them togather...
11:09:44 matherp@MACC02X9DETJG5H in ~ ➜ ls -la .aws/
total 24
drwxr-xr-x   7 matherp  CORP\Domain Users   224  7 Apr 10:55 .
drwxr-x---+ 47 matherp  CORP\Domain Users  1504  7 Apr 10:56 ..
drwxr-xr-x  27 matherp  CORP\Domain Users   864 17 Mar 11:38 chromium
drwxr-xr-x   3 matherp  CORP\Domain Users    96  2 Apr 11:00 cli
-rw-r--r--   1 matherp  CORP\Domain Users  1490  7 Apr 10:49 config
-rw-r--r--   1 matherp  CORP\Domain Users   842  6 Apr 14:29 config.aws
-rw-r--r--   1 matherp  CORP\Domain Users   647  7 Apr 10:39 config.azure

# I cleaned out an sso directory and this cli cache directory before I started to remove all creds...
11:09:48 matherp@MACC02X9DETJG5H in ~ ➜ ls -la .aws/cli/cache/
total 0
drwxr-xr-x  2 matherp  CORP\Domain Users  64  7 Apr 11:07 .
drwxr-xr-x  3 matherp  CORP\Domain Users  96  2 Apr 11:00 ..

# As such I have no tokens or access...
11:11:20 matherp@MACC02X9DETJG5H in ~ ➜ aws sts get-caller-identity
Error loading SSO Token: The SSO access token has either expired or is otherwise invalid.

# I leave the default as SSO 
11:09:53 matherp@MACC02X9DETJG5H in ~ ➜ cat .aws/config.aws .aws/config.azure > .aws/config
11:09:53 matherp@MACC02X9DETJG5H in ~ ➜ cat .aws/config
[default]
sso_start_url = https://d-93670ced1d.awsapps.com/start
sso_region = eu-west-1
sso_account_id = 906883863167
sso_role_name = InfraAdmin
region = eu-west-1
output = json
cli_auto_prompt=on-partial

[profile tribe-dev-developerAdmin]
sso_start_url = https://d-93670ced1d.awsapps.com/start
sso_region = eu-west-1
sso_account_id = 069140385617
sso_role_name = tribe-dev-developerAdmin
region = eu-west-1
output = json
cli_auto_prompt=on-partial

[profile tribe-prod-developerAdmin]
sso_start_url = https://d-93670ced1d.awsapps.com/start
sso_region = eu-west-1
sso_account_id = 184009931817
sso_role_name = tribe-prod-developerAdmin
region = eu-west-1
output = json
cli_auto_prompt=on-partial

[profile tribe-tooling-developerAdmin]
sso_start_url = https://d-93670ced1d.awsapps.com/start
sso_region = eu-west-1
sso_account_id = 330941722859
sso_role_name = tribe-tooling-developerAdmin
region = eu-west-1
output = json
cli_auto_prompt=on-partial

#[default]
[profile aws-lz-dev]
azure_tenant_id=7acc61c5-e4a5-49d2-a52a-3ce24c726371
azure_app_id_uri=https://signin.aws.amazon.com/saml
azure_default_username=philip.mather@paddypowerbetfair.com
azure_default_role_arn=
azure_default_duration_hours=1
azure_default_remember_me=true
region=eu-west-1
cli_auto_prompt=on-partial

[profile aws-lz-prod]
azure_tenant_id=7acc61c5-e4a5-49d2-a52a-3ce24c726371
azure_app_id_uri=https://signin.aws.amazon.com/saml/AWS
azure_default_username=philip.mather@paddypowerbetfair.com
azure_default_role_arn=
azure_default_duration_hours=1
azure_default_remember_me=true
region=eu-west-1
cli_auto_prompt=on-partial

# As Azure AD is in dev and prod I prefer to have no default, especially as SSO can be the default...
11:11:35 matherp@MACC02X9DETJG5H in ~ ➜ aws-azure-login
Profile 'default' is not configured properly.

11:11:55 matherp@MACC02X9DETJG5H in ~ ✗  aws-azure-login --profile aws-lz-dev
Logging in with profile 'aws-lz-dev'...
Using AWS SAML endpoint https://signin.aws.amazon.com/saml
? Role: arn:aws:iam::326159127752:role/aws-lzsoc-dev-infraadmin
? Session Duration Hours (up to 12): 1
Assuming role arn:aws:iam::326159127752:role/aws-lzsoc-dev-infraadmin

11:12:14 matherp@MACC02X9DETJG5H in ~ ✗  aws sts get-caller-identity --profile aws-lz-dev
{
    "UserId": "AROAUX4EZKTEPQEQEYIAO:philip.mather@paddypowerbetfair.com",
    "Account": "326159127752",
    "Arn": "arn:aws:sts::326159127752:assumed-role/aws-lzsoc-dev-infraadmin/philip.mather@paddypowerbetfair.com"
}

11:12:18 matherp@MACC02X9DETJG5H in ~ ➜ aws-azure-login --profile aws-lz-prod
Logging in with profile 'aws-lz-prod'...
Using AWS SAML endpoint https://signin.aws.amazon.com/saml
? Role: arn:aws:iam::286909689322:role/aws-286909689322-infraadmin
? Session Duration Hours (up to 12): 1
Assuming role arn:aws:iam::286909689322:role/aws-286909689322-infraadmin

11:12:30 matherp@MACC02X9DETJG5H in ~ ➜ aws sts get-caller-identity --profile aws-lz-prod
{
    "UserId": "AROAUFTJGNXVFMCKELJ5W:philip.mather@paddypowerbetfair.com",
    "Account": "286909689322",
    "Arn": "arn:aws:sts::286909689322:assumed-role/aws-286909689322-infraadmin/philip.mather@paddypowerbetfair.com"
}

11:12:36 matherp@MACC02X9DETJG5H in ~ ➜ ls -la .aws/credentials
-rw-r--r--  1 matherp  CORP\Domain Users  1394  7 Apr 11:12 .aws/credentials

11:12:58 matherp@MACC02X9DETJG5H in ~ ➜ ls -la .aws/cli/cache/
total 0
drwxr-xr-x  2 matherp  CORP\Domain Users  64  7 Apr 11:07 .
drwxr-xr-x  3 matherp  CORP\Domain Users  96  2 Apr 11:00 ..

11:13:06 matherp@MACC02X9DETJG5H in ~ ➜ aws sso login
Attempting to automatically open the SSO authorization page in your default browser.
If the browser does not open or you wish to use a different device to authorize this request, open the following URL:

https://device.sso.eu-west-1.amazonaws.com/

Then enter the code:

HZPT-SPRN
Successfully logged into Start URL: https://d-93670ced1d.awsapps.com/start

11:13:33 matherp@MACC02X9DETJG5H in ~ ➜ aws sts get-caller-identity
{
    "UserId": "AROA5GJT5SJ7XPAABPOE6:philip.mather@paddypowerbetfair.com",
    "Account": "906883863167",
    "Arn": "arn:aws:sts::906883863167:assumed-role/AWSReservedSSO_InfraAdmin_ddf68f2f2ef15701/philip.mather@paddypowerbetfair.com"
}

11:14:23 matherp@MACC02X9DETJG5H in ~ ➜ ls -la .aws/sso/cache/
total 16
drwxr-xr-x  4 matherp  CORP\Domain Users   128  7 Apr 11:13 .
drwxr-xr-x  3 matherp  CORP\Domain Users    96  7 Apr 11:13 ..
-rw-------  1 matherp  CORP\Domain Users   980  7 Apr 11:13 botocore-client-id-eu-west-1.json
-rw-------  1 matherp  CORP\Domain Users  1389  7 Apr 11:13 da56c5f5a74dbe7acd8501d11fec5a7d74d975b8.json

11:14:30 matherp@MACC02X9DETJG5H in ~ ➜ ls -la .aws/cli/cache/
total 8
drwxr-xr-x  3 matherp  CORP\Domain Users    96  7 Apr 11:14 .
drwxr-xr-x  3 matherp  CORP\Domain Users    96  2 Apr 11:00 ..
-rw-------  1 matherp  CORP\Domain Users  1156  7 Apr 11:14 889bd370a6e1df37d5ad6fb2357acb72a1c6ad22.json
```

# Expiremental
This deploys an EKS Anywhere cluster to your machine
You must disable the expiriemental "Enable VirtioFS accelerated directory sharing" option in docker desktop otherwise you get a super cryptic permission denied message

https://anywhere.eks.amazonaws.com/docs/reference/clusterspec/gitops/

```
13:34:32 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main➜ brew install aws/tap/eks-anywhere
Running `brew update --preinstall`...
==> Auto-updated Homebrew!
Updated 2 taps (homebrew/core and homebrew/services).
==> New Formulae
acl                   cloudflare-quiche     criterion             ddcutil               easeprobe             flyctl                gi-docgen             ifacemaker            jdtls                 libcython             mariadb@10.6          mongodb-atlas-cli     nvchecker             powerman-dockerize    shadowsocks-rust      ugit
autocannon            compiledb             dagger                difftastic            epinio                fourmolu              highs                 inih                  kmod                  ltex-ls               melody                nickel                openjdk@17            rslint                stylish-haskell       wasm-tools
==> Updated Formulae
Updated 1286 formulae.
==> Deleted Formulae
autopano-sift-c                                                                            griffon                                                                                    gstreamermm                                                                                mozilla-addon-sdk

==> Tapping aws/tap
Cloning into '/usr/local/Homebrew/Library/Taps/aws/homebrew-tap'...
remote: Enumerating objects: 3089, done.
remote: Counting objects: 100% (1852/1852), done.
remote: Compressing objects: 100% (637/637), done.
remote: Total 3089 (delta 1518), reused 1462 (delta 1213), pack-reused 1237
Receiving objects: 100% (3089/3089), 481.32 KiB | 2.62 MiB/s, done.
Resolving deltas: 100% (2179/2179), done.
Tapped 16 formulae (49 files, 625.7KB).
==> Downloading https://ghcr.io/v2/homebrew/core/aws-iam-authenticator/manifests/0.5.5
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/aws-iam-authenticator/blobs/sha256:b4b7f41452eab334fd6be0cf72c03fe1a53ea4fbf454c16e220ca8b48b5d455c
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:b4b7f41452eab334fd6be0cf72c03fe1a53ea4fbf454c16e220ca8b48b5d455c?se=2022-04-07T12%3A45%3A00Z&sig=Uuk2mdYBDX6wYhnykUU4n35aTns0zutbdectVHodRd4%3D&sp=r&spr=https&sr=b&sv=2019-12-12
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/eksctl/manifests/0.90.0
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/eksctl/blobs/sha256:2c36a17090e4352c893a098854eb1bba08c63dff9a4b31d089af1a3771d120b9
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:2c36a17090e4352c893a098854eb1bba08c63dff9a4b31d089af1a3771d120b9?se=2022-04-07T12%3A45%3A00Z&sig=4%2BJnELWNDiCrpnvNDy1UsgXow4ksoXYqud6IWWlEIHw%3D&sp=r&spr=https&sr=b&sv=2019-12-12
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/kubernetes-cli/manifests/1.23.5
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/kubernetes-cli/blobs/sha256:cfa5d59c7c0181869b635fbf5383e1178e0c6cd43de504237498d64a1be31748
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:cfa5d59c7c0181869b635fbf5383e1178e0c6cd43de504237498d64a1be31748?se=2022-04-07T12%3A45%3A00Z&sig=i%2FKpkWlH0HCYvtzw8PVH4nDMGCS6DGDcLu5529d5MI4%3D&sp=r&spr=https&sr=b&sv=2019-12-12
######################################################################## 100.0%
==> Downloading https://anywhere-assets.eks.amazonaws.com/releases/eks-a/8/artifacts/eks-a/v0.8.0/darwin/amd64/eksctl-anywhere-v0.8.0-darwin-amd64.tar.gz
######################################################################## 100.0%
==> Installing eks-anywhere from aws/tap
==> Installing dependencies for aws/tap/eks-anywhere: aws-iam-authenticator, eksctl and kubernetes-cli
==> Installing aws/tap/eks-anywhere dependency: aws-iam-authenticator
==> Pouring aws-iam-authenticator--0.5.5.monterey.bottle.tar.gz
🍺  /usr/local/Cellar/aws-iam-authenticator/0.5.5: 6 files, 48.8MB
==> Installing aws/tap/eks-anywhere dependency: eksctl
==> Pouring eksctl--0.90.0.monterey.bottle.tar.gz
🍺  /usr/local/Cellar/eksctl/0.90.0: 8 files, 116.6MB
==> Installing aws/tap/eks-anywhere dependency: kubernetes-cli
==> Pouring kubernetes-cli--1.23.5.monterey.bottle.tar.gz
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink bin/kubectl
Target /usr/local/bin/kubectl
already exists. You may want to remove it:
  rm '/usr/local/bin/kubectl'

To force the link and overwrite all conflicting files:
  brew link --overwrite kubernetes-cli

To list all files that would be deleted:
  brew link --overwrite --dry-run kubernetes-cli

Possible conflicting files are:
/usr/local/bin/kubectl -> /Applications/Docker.app/Contents/Resources/bin/kubectl
==> Summary
🍺  /usr/local/Cellar/kubernetes-cli/1.23.5: 227 files, 56.8MB
==> Installing aws/tap/eks-anywhere
🍺  /usr/local/Cellar/eks-anywhere/0.8.0: 3 files, 47.0MB, built in 5 seconds
==> Running `brew cleanup eks-anywhere`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).

14:00:55 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main➜ kubectl describe nodes
Name:               docker-desktop
Roles:              control-plane,master
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=docker-desktop
                    kubernetes.io/os=linux
                    node-role.kubernetes.io/control-plane=
                    node-role.kubernetes.io/master=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        kubeadm.alpha.kubernetes.io/cri-socket: /var/run/dockershim.sock
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Fri, 01 Apr 2022 15:01:45 +0100
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  docker-desktop
  AcquireTime:     <unset>
  RenewTime:       Thu, 07 Apr 2022 14:01:08 +0100
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Thu, 07 Apr 2022 14:01:03 +0100   Fri, 01 Apr 2022 15:01:43 +0100   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 07 Apr 2022 14:01:03 +0100   Fri, 01 Apr 2022 15:01:43 +0100   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 07 Apr 2022 14:01:03 +0100   Fri, 01 Apr 2022 15:01:43 +0100   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 07 Apr 2022 14:01:03 +0100   Fri, 01 Apr 2022 15:02:15 +0100   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  192.168.65.4
  Hostname:    docker-desktop
Capacity:
  cpu:                6
  ephemeral-storage:  61255492Ki
  hugepages-2Mi:      0
  memory:             8048476Ki
  pods:               110
Allocatable:
  cpu:                6
  ephemeral-storage:  56453061334
  hugepages-2Mi:      0
  memory:             7946076Ki
  pods:               110
System Info:
  Machine ID:                 c9b87f4d-0810-4707-b15c-453358b62e17
  System UUID:                c9b87f4d-0810-4707-b15c-453358b62e17
  Boot ID:                    00e0a119-248f-4cb9-a68c-a440f75c064c
  Kernel Version:             5.10.104-linuxkit
  OS Image:                   Docker Desktop
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  docker://20.10.13
  Kubelet Version:            v1.22.5
  Kube-Proxy Version:         v1.22.5
Non-terminated Pods:          (9 in total)
  Namespace                   Name                                      CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                      ------------  ----------  ---------------  -------------  ---
  kube-system                 coredns-78fcd69978-q9tkt                  100m (1%)     0 (0%)      70Mi (0%)        170Mi (2%)     5d22h
  kube-system                 coredns-78fcd69978-wbqvq                  100m (1%)     0 (0%)      70Mi (0%)        170Mi (2%)     5d22h
  kube-system                 etcd-docker-desktop                       100m (1%)     0 (0%)      100Mi (1%)       0 (0%)         5d22h
  kube-system                 kube-apiserver-docker-desktop             250m (4%)     0 (0%)      0 (0%)           0 (0%)         5d22h
  kube-system                 kube-controller-manager-docker-desktop    200m (3%)     0 (0%)      0 (0%)           0 (0%)         5d22h
  kube-system                 kube-proxy-dj8kg                          0 (0%)        0 (0%)      0 (0%)           0 (0%)         5d22h
  kube-system                 kube-scheduler-docker-desktop             100m (1%)     0 (0%)      0 (0%)           0 (0%)         5d22h
  kube-system                 storage-provisioner                       0 (0%)        0 (0%)      0 (0%)           0 (0%)         5d22h
  kube-system                 vpnkit-controller                         0 (0%)        0 (0%)      0 (0%)           0 (0%)         5d22h
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                850m (14%)  0 (0%)
  memory             240Mi (3%)  340Mi (4%)
  ephemeral-storage  0 (0%)      0 (0%)
  hugepages-2Mi      0 (0%)      0 (0%)
Events:              <none>

14:01:48 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main➜ CLUSTER_NAME=dev-cluster
14:05:34 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main➜ eksctl anywhere generate clusterconfig $CLUSTER_NAME --provider docker > $CLUSTER_NAME.yaml

14:11:37 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ eksctl anywhere create cluster -f $CLUSTER_NAME.yaml
Error: failed to validate docker desktop: EKS Anywhere requires Docker desktop to be configured to use CGroups v1. Please  set `deprecatedCgroupv1:true` in your `~/Library/Group\ Containers/group.com.docker/settings.json` file

14:17:02 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ sed -i '' -e 's/"deprecatedCgroupv1": false,/"deprecatedCgroupv1": true,/' ~/Library/Group\ Containers/group.com.docker/settings.json

# Restart docker desktop as well

22:24:11 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ eksctl anywhere create cluster -f $CLUSTER_NAME.yaml
Performing setup and validations
Warning: The docker infrastructure provider is meant for local development and testing only
✅ Docker Provider setup is valid
✅ Validate certificate for registry mirror
✅ Create preflight validations pass
Creating new bootstrap cluster
Installing cluster-api providers on bootstrap cluster
Provider specific post-setup
Creating new workload cluster
Installing networking on workload cluster
Installing storage class on workload cluster
Installing cluster-api providers on workload cluster
Installing EKS-A secrets on workload cluster
Moving cluster management from bootstrap to workload cluster
Installing EKS-A custom components (CRD and controller) on workload cluster
Creating EKS-A CRDs instances on workload cluster
Installing AddonManager and GitOps Toolkit on workload cluster
GitOps field not specified, bootstrap flux skipped
Writing cluster config file
Deleting bootstrap cluster
🎉 Cluster created!

22:29:05 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ export KUBECONFIG=${PWD}/${CLUSTER_NAME}/${CLUSTER_NAME}-eks-a-cluster.kubeconfig
22:31:05 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ kubectl get ns
NAME                                STATUS   AGE
capd-system                         Active   3m
capi-kubeadm-bootstrap-system       Active   3m7s
capi-kubeadm-control-plane-system   Active   3m2s
capi-system                         Active   3m8s
cert-manager                        Active   4m3s
default                             Active   4m38s
eksa-system                         Active   2m37s
etcdadm-bootstrap-provider-system   Active   3m6s
etcdadm-controller-system           Active   3m4s
kube-node-lease                     Active   4m40s
kube-public                         Active   4m40s
kube-system                         Active   4m40s
22:31:09 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ kubectl apply -f "https://anywhere.eks.amazonaws.com/manifests/hello-eks-a.yaml"
deployment.apps/hello-eks-a created
service/hello-eks-a created

22:31:22 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ kubectl get pods -l app=hello-eks-a
NAME                          READY   STATUS    RESTARTS   AGE
hello-eks-a-9644dd8dc-m9sg8   1/1     Running   0          38s
22:32:01 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ kubectl logs -l app=hello-eks-a
2022/04/12 21:31:29 [notice] 1#1: built by gcc 10.3.1 20211027 (Alpine 10.3.1_git20211027)
2022/04/12 21:31:29 [notice] 1#1: OS: Linux 5.10.104-linuxkit
2022/04/12 21:31:29 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/04/12 21:31:29 [notice] 1#1: start worker processes
2022/04/12 21:31:29 [notice] 1#1: start worker process 38
2022/04/12 21:31:29 [notice] 1#1: start worker process 39
2022/04/12 21:31:29 [notice] 1#1: start worker process 40
2022/04/12 21:31:29 [notice] 1#1: start worker process 41
2022/04/12 21:31:29 [notice] 1#1: start worker process 42
2022/04/12 21:31:29 [notice] 1#1: start worker process 43
22:32:12 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ kubectl port-forward deploy/hello-eks-a 8000:80
Forwarding from 127.0.0.1:8000 -> 80
Forwarding from [::1]:8000 -> 80
^Z
[1]+  Stopped                 kubectl port-forward deploy/hello-eks-a 8000:80
22:32:39 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ✗  bg
[1]+ kubectl port-forward deploy/hello-eks-a 8000:80 &
22:32:41 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ curl localhost:8000
Handling connection for 8000
⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢

Thank you for using

███████╗██╗  ██╗███████╗
██╔════╝██║ ██╔╝██╔════╝
█████╗  █████╔╝ ███████╗
██╔══╝  ██╔═██╗ ╚════██║
███████╗██║  ██╗███████║
╚══════╝╚═╝  ╚═╝╚══════╝

 █████╗ ███╗   ██╗██╗   ██╗██╗    ██╗██╗  ██╗███████╗██████╗ ███████╗
██╔══██╗████╗  ██║╚██╗ ██╔╝██║    ██║██║  ██║██╔════╝██╔══██╗██╔════╝
███████║██╔██╗ ██║ ╚████╔╝ ██║ █╗ ██║███████║█████╗  ██████╔╝█████╗
██╔══██║██║╚██╗██║  ╚██╔╝  ██║███╗██║██╔══██║██╔══╝  ██╔══██╗██╔══╝
██║  ██║██║ ╚████║   ██║   ╚███╔███╔╝██║  ██║███████╗██║  ██║███████╗
╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝

You have successfully deployed the hello-eks-a pod hello-eks-a-9644dd8dc-m9sg8

For more information check out
https://anywhere.eks.amazonaws.com

⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢⬡⬢
22:32:51 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ kill %1
[1]+  Terminated: 15          kubectl port-forward deploy/hello-eks-a 8000:80
22:32:58 matherp@MACC02X9DETJG5H in …/docker-dev-envs on 🌱main[🤷] ➜ curl localhost:8000
curl: (7) Failed to connect to localhost port 8000 after 5 ms: Connection refused


```

## Next
- https://anywhere.eks.amazonaws.com/docs/tasks/cluster/cluster-connect/
- https://anywhere.eks.amazonaws.com/docs/tasks/cluster/cluster-iam-auth/ ?
- https://anywhere.eks.amazonaws.com/docs/tasks/cluster/cluster-delete/


## Later
- https://cli.github.com/manual/gh_release_create
- change make gitTag to make tag for both github and docker
- add make release that adds tagged docker image to github and releases
- cdk-nag
- https://aws.amazon.com/blogs/containers/how-to-automate-amazon-eks-preventative-controls-in-ci-cd-using-cdk-and-opa-conftest/
- https://docs.aws.amazon.com/cdk/api/v1/docs/aws-eks-readme.html
- https://aws.amazon.com/blogs/architecture/field-notes-managing-an-amazon-eks-cluster-using-aws-cdk-and-cloud-resource-property-manager/
- Investigate https://app.snyk.io/account
- https://blog.beachgeek.co.uk/
- https://www.eksworkshop.com/
- https://www.eksworkshop.com/beginner/190_ocean/
- https://www.eksworkshop.com/020_prerequisites/workspace/
