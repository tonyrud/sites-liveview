variable "prefix" {
  type        = string
  default     = "sites"
  description = "Base prefix for all resources"
}

variable "project" {
  type    = string
  default = "sites-app"
}

variable "contact" {
  type    = string
  default = "tonrudny@gmail.com"
}

variable "db_username" {
  type        = string
  description = "Username for RDS Instance"
}

variable "db_password" {
  type        = string
  description = "Password for RDS Instance"
}

variable "bastion_key_name" {
  default = "sites-devops-bastion"
}

