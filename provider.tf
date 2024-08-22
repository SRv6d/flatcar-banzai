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
  user_name = var.user_name
  password  = var.password
  auth_url  = var.auth_url
  region    = var.region
}
