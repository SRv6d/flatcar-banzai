# SSH Key
resource "openstack_compute_keypair_v2" "generic" {
  name       = "generic"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOELWzSrWOfYX4B7v0kYnIyQT3M3wVV1c6X+LpoJFDcI"
}

resource "openstack_blockstorage_volume_v3" "data" {
  name = "banzai"
  size = 1000
}
