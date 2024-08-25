terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

provider "openstack" {
  tenant_id = var.os_project_id
  user_name = var.os_user_name
  password  = var.os_password
  auth_url  = var.os_auth_url
  region    = var.os_region
}

provider "cloudflare" {
  api_token = var.cf_api_token
}

