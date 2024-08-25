variable "os_project_id" {
  type        = string
  description = "OpenStack project ID"
}

variable "os_user_name" {
  type        = string
  description = "OpenStack username"
}

variable "os_password" {
  type        = string
  description = "OpenStack password"
  sensitive   = true
}

variable "os_auth_url" {
  type        = string
  description = "OpenStack Keystone URL"
}

variable "os_region" {
  type        = string
  description = "OpenStack region"
}

variable "cf_api_token" {
  type        = string
  description = "CloudFlare API token"
  sensitive   = true
}

variable "cf_zone_id" {
  type        = string
  description = "CloudFlare DNS Zone ID"
}
