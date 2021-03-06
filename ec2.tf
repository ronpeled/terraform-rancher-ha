#------------------------------------------#
# EC2 Instance Configuration
#------------------------------------------#
# User-data template
data "template_file" "user_data" {
    template = "${file("${path.module}/files/userdata.template")}"

    vars {
        # Database
        db_address            = "${aws_rds_cluster.rancher_ha.endpoint}"
        db_port               = "${var.db_port}"
        db_name               = "${var.db_name}"
        db_username           = "${var.db_username}"
        db_password           = "${var.db_password}"
        db_encrypted_password = "${var.db_encrypted_password}"
        ha_registration_url   = "https://${var.rancher_endpoint_name}"
        scale_desired_size    = "${var.scale_desired_size}"
        rancher_version       = "${var.rancher_version}"
        encryption_key        = "${var.ha_encryption_key}"
    }
}

resource "aws_key_pair" "rancher" {
    key_name = "${var.key_name}"
    public_key = "${file("${var.key_path}.pub")}"
}

resource "aws_instance" "rancher_ha_a" {
    ami                         = "${lookup(var.ami, var.region)}"
    instance_type               = "${var.instance_type}"
    availability_zone           = "${var.region}a"
    key_name                    = "${aws_key_pair.rancher.key_name}"
    subnet_id                   = "${aws_subnet.rancher_ha_a.id}"
    security_groups             = ["${aws_security_group.rancher_ha.id}"]
    associate_public_ip_address = true
    user_data                   = "${data.template_file.user_data.rendered}"

    tags {
        Name = "${var.tag_name}-instance-a"
    }

    root_block_device {
        volume_size = "100"
        delete_on_termination = true
    }
}

resource "aws_instance" "rancher_ha_b" {
    ami                         = "${lookup(var.ami, var.region)}"
    instance_type               = "${var.instance_type}"
    availability_zone           = "${var.region}b"
    key_name                    = "${aws_key_pair.rancher.key_name}"
    subnet_id                   = "${aws_subnet.rancher_ha_b.id}"
    security_groups             = ["${aws_security_group.rancher_ha.id}"]
    associate_public_ip_address = true
    user_data                   = "${data.template_file.user_data.rendered}"

    tags {
        Name = "${var.tag_name}-instance-b"
    }

    root_block_device {
        volume_size = "100"
        delete_on_termination = true
    }
}

resource "aws_instance" "rancher_ha_d" {
    ami                         = "${lookup(var.ami, var.region)}"
    instance_type               = "${var.instance_type}"
    availability_zone           = "${var.region}d"
    key_name                    = "${aws_key_pair.rancher.key_name}"
    subnet_id                   = "${aws_subnet.rancher_ha_b.id}"
    subnet_id                   = "${aws_subnet.rancher_ha_d.id}"
    security_groups             = ["${aws_security_group.rancher_ha.id}"]
    associate_public_ip_address = true
    user_data                   = "${data.template_file.user_data.rendered}"

    tags {
        Name = "${var.tag_name}-instance-d"
    }

    root_block_device {
        volume_size = "100"
        delete_on_termination = true
    }
}

resource "aws_security_group" "rancher_ha" {
    name        = "${var.tag_name}-secgroup"
    description = "Rancher HA Ports"
    vpc_id      = "${aws_vpc.rancher_ha.id}"

    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "tcp"
        self      = true
    }

    ingress {
        from_port = 0
        to_port   = 65535
        protocol  = "udp"
        self      = true
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["192.168.99.0/24"]
    }

    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "udp"
        cidr_blocks = ["192.168.99.0/24"]
    }

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
