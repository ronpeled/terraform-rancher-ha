# Create the private key for the registration (not the certificate)
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# Set up a registration using a private key from tls_private_key
resource "acme_registration" "reg" {
  server_url      = "https://acme-v01.api.letsencrypt.org/directory"
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "michael.laccetti@points.com"
}

# Create a certificate
resource "acme_certificate" "certificate" {
  server_url                = "https://acme-v01.api.letsencrypt.org/directory"
  account_key_pem           = "${tls_private_key.private_key.private_key_pem}"
  common_name               = "rancher.pointsaws.com"
  # subject_alternative_names = ["www2.example.com"]

  dns_challenge {
    provider = "route53"
    config {
      AWS_ACCESS_KEY_ID     = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
      AWS_DEFAULT_REGION    = "us-east-1"
    }
  }

  registration_url = "${acme_registration.reg.id}"
}
