resource "cloudflare_record" "banzai-v6" {
  zone_id = var.cf_zone_id
  name    = "banzai"
  content = trim(openstack_compute_instance_v2.instance.access_ip_v6, "[]") // Trim used as workaround for https://github.com/terraform-provider-openstack/terraform-provider-openstack/issues/1357
  type    = "AAAA"
  ttl     = 300
}

resource "cloudflare_record" "banzai-v4" {
  zone_id = var.cf_zone_id
  name    = "banzai"
  content = openstack_networking_floatingip_v2.default.address
  type    = "A"
  ttl     = 300
}
