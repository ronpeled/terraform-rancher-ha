# terraform-rancher-ha
Terraform files for deploying a Rancher HA cluster in AWS

These files are meant as a companion to the following blog post:

[https://thisendout.com/2016/05/04/deploying-rancher-with-ha-using-rancheros-aws-terraform-letsencrypt/](https://thisendout.com/2016/05/04/deploying-rancher-with-ha-using-rancheros-aws-terraform-letsencrypt/)

## Usage

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
