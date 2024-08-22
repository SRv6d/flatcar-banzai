terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  tenant_id = var.project_id
  auth_url  = "https://identity.optimist.gec.io/v3"
  region    = "fra"
}
