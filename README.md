# terraform-rancher-ha
Terraform files for deploying a Rancher HA cluster in AWS

These files are meant as a companion to the following blog post:

[https://thisendout.com/2016/05/04/deploying-rancher-with-ha-using-rancheros-aws-terraform-letsencrypt/](https://thisendout.com/2016/05/04/deploying-rancher-with-ha-using-rancheros-aws-terraform-letsencrypt/)

## Usage

Grab the latest release of the ACME provider and install it:

```bash
mkdir -p ~/.terraform.d
curl -LS https://github.com/paybyphone/terraform-provider-acme/releases/download/v0.1.0/terraform-provider-acme_v0.1.0_darwin_amd64.zip | unzip -d ~/.terraform.d
terraformrc="providers {
  acme = "~/.terraform.d/terraform-provider-acme"
}"
echo $terraformrc > ~/.terraformrc
```

Create a `terraform.tfvars` file with the following contents:

```
# aws access and secret keys
# could also be exported as ENV vars, but included here for simplicity
access_key = ""
secret_key = ""

# database password rancher uses to connect to RDS
db_password = "rancherdbpass"
```

To create the cluster:

```
terraform apply
```

To destroy:

```
terraform destroy
```

These files are only meant to create the infrastructure needed to run Rancher with HA in AWS. Configuring and deploying Rancher will need to be done independently (see blog post for details).

```
ssh -i ./ssh/rancher rancher@52.91.243.49 docker run -d \
    --name rancher-bootstrap -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e CATTLE_DB_CATTLE_MYSQL_HOST=rancher-ha-db.cluster-csp6yp29pzkx.us-east-1.rds.amazonaws.com \
    -e CATTLE_DB_CATTLE_MYSQL_NAME=rancher \
    -e CATTLE_DB_CATTLE_MYSQL_PORT=3306 \
    -e CATTLE_DB_CATTLE_PASSWORD=shorten-tilt-covenant-mesmeric-blandish \
    -e CATTLE_DB_CATTLE_USERNAME=rancher \
    rancher/server:v1.1.3
```

```
SCRIPT_PATH=~/Downloads/rancher-ha.sh

# using the ip's from the terraform output...
for ip in 52.91.243.49 54.89.59.25 52.91.63.123; do
  scp -i ~/.ssh/rancher-example ${SCRIPT_PATH} rancher@${ip}:~/rancher-ha.sh
  ssh -i ~/.ssh/rancher-example rancher@${ip} sudo bash rancher-ha.sh rancher/server:v1.1.3
done
```

```
ssh -i ./ssh/rancher rancher@52.91.243.49 docker logs -f rancher-ha
```
