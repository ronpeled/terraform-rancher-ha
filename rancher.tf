resource "rancher" "bootstrap" {
  provisioner "local-exec" {
    command = "ssh -i ${var.key_path} rancher@${aws_instance.rancher_ha_a.public_ip} docker run -d \
    --name rancher-bootstrap -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e CATTLE_DB_CATTLE_MYSQL_HOST=${aws_rds_cluster_instance.rancher_ha.endpoint}\
    -e CATTLE_DB_CATTLE_MYSQL_NAME=rancher \
    -e CATTLE_DB_CATTLE_MYSQL_PORT=3306 \
    -e CATTLE_DB_CATTLE_PASSWORD=${var.db_password} \
    -e CATTLE_DB_CATTLE_USERNAME=rancher \
    rancher/server:v1.1.3"
  }
}
