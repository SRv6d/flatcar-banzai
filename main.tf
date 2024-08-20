# SSH Key
resource "openstack_compute_keypair_v2" "generic" {
  name       = "generic"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOELWzSrWOfYX4B7v0kYnIyQT3M3wVV1c6X+LpoJFDcI"
}

resource "openstack_blockstorage_volume_v3" "data" {
  name = "banzai"
  size = 1000
}

resource "openstack_compute_instance_v2" "instance" {
  name                = "banzai"
  image_name          = "Flatcar_Production - Latest"
  flavor_name         = "s1.medium"
  key_pair            = openstack_compute_keypair_v2.generic.name
  config_drive        = true
  stop_before_destroy = true

  network {
    uuid = openstack_networking_network_v2.network.id
  }
  security_groups = ["default", "allow-all"]

  user_data = file("ignition.json")
}
resource "openstack_compute_volume_attach_v2" "attached" {
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.data.id
}
