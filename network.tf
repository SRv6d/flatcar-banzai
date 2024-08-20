resource "openstack_networking_network_v2" "network" {
  name      = "banzai-network"
  tenant_id = var.project_id
}
resource "openstack_networking_subnet_v2" "subnet-v4" {
  network_id = openstack_networking_network_v2.network.id
  ip_version = 4
  cidr       = "172.31.255.0/24"
  tenant_id  = var.project_id
}
resource "openstack_networking_subnet_v2" "subnet-v6" {
  network_id    = openstack_networking_network_v2.network.id
  ip_version    = 6
  subnetpool_id = "f541f3b6-af22-435a-9cbb-b233d12e74f4"
  tenant_id     = var.project_id
}

resource "openstack_networking_secgroup_v2" "allow-all" {
  name        = "allow-all"
  description = "Allow all inbound traffic"
  tenant_id   = var.project_id
}
resource "openstack_networking_secgroup_rule_v2" "allow-v4-udp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.allow-all.id
}
resource "openstack_networking_secgroup_rule_v2" "allow-v6-udp" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "udp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.allow-all.id
}
resource "openstack_networking_secgroup_rule_v2" "allow-v4-tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.allow-all.id
}
resource "openstack_networking_secgroup_rule_v2" "allow-v6-tcp" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.allow-all.id
}
resource "openstack_networking_secgroup_rule_v2" "allow-v4-icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.allow-all.id
}
resource "openstack_networking_secgroup_rule_v2" "allow-v6-icmp" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_ip_prefix  = "::/0"
  security_group_id = openstack_networking_secgroup_v2.allow-all.id
}
