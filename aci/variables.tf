variable "prefix" {
  type = string
}

variable "url" {
  type = string
}

variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type      = string
  sensitive = true
}

variable "switch" {
  type = string
}

variable "switch_user" {
  type = string
}

variable "switch_password" {
  type      = string
  sensitive = true
}

variable "switch_ssh_port" {
  type = number
}

variable "switch_http_port" {
  type = number
}

variable "switch_hostname" {
  type = string
}