terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = "~> 0.7"
    }
  }
}

provider "aci" {
  username = var.username
  password = var.password
  url      = var.url
  insecure = true
}