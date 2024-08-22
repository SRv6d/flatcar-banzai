variable "project_id" {
  type        = string
  description = "OpenStack project ID"
}

variable "user_name" {
  type        = string
  description = "OpenStack username"
}

variable "password" {
  type        = string
  description = "OpenStack password"
  sensitive   = true
}

variable "auth_url" {
  type        = string
  description = "OpenStack Keystone URL"
}

variable "region" {
  type        = string
  description = "OpenStack region"
}
