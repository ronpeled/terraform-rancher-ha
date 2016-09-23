resource "aws_route53_zone" "primary" {
   name = "pointsaws.com"
}

resource "aws_route53_record" "rancher" {
  zone_id = "${aws_route53_zone.primary.id}"
  name = "pointsaws.com"
  type = "A"

  alias {
    name = "${aws_elb.rancher_ha.dns_name}"
    zone_id = "${aws_elb.rancher_ha.zone_id}"
    evaluate_target_health = true
  }
}
