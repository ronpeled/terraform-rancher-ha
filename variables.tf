#------------------------------------------#
# AWS Environment Values
#------------------------------------------#
variable "access_key" {
    description = "AWS account access key ID"
}

variable "secret_key" {
    description = "AWS account secret access key"
}

variable "region" {
    default     = "us-east-1"
    description = "The region of AWS, for AMI lookups."
}

variable "ami" {
    description = "AWS RancherOS AMI ID"
    default {
        us-east-1 = "ami-a8d2a4bf"
        us-west-1 = "ami-fccb879c"
        us-west-2 = "ami-1ed3007e"
    }
}

variable "key_name" {
    default = "rancher-example"
    description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
    default = "~/.ssh/rancher-example"
    description = "Local path of the SSH private key"
}

variable "instance_type" {
    default     = "t2.large" # RAM Requirements >= 8gb
    description = "AWS Instance type"
}

variable "tag_name" {
    default     = "rancher-ha"
    description = "Name tag for the servers"
}

variable "vpc_cidr" {
    default     = "192.168.99.0/24"
    description = "Subnet in CIDR format to assign to VPC"
}

variable "db_password" {
    description = "Password for connecting to the rancher RDS database"
}
