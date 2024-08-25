resource "cloudflare_record" "banzai-v6" {
  zone_id = var.cf_zone_id
  name    = "banzai"
  content = openstack_compute_instance_v2.instance.access_ip_v6
  type    = "AAAA"
  ttl     = 300
}

resource "cloudflare_record" "banzai-v4" {
  zone_id = var.cf_zone_id
  name    = "banzai"
  content = openstack_compute_instance_v2.instance.access_ip_v4
  type    = "A"
  ttl     = 300
}
