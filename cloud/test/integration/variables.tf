variable "region" {
  type = string
}

variable "main_project_tag" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "key_pair_name" {
  type = string
}

variable "key_pair_private_key_path" {
  type = string
}