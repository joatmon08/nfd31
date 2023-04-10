locals {
  annotation = "orchestrator:terraform"
}

resource "aci_tenant" "dev" {
  description = "This tenant is created by Terraform"
  name        = "${var.prefix}_tenant"
  annotation  = local.annotation
}

resource "aci_application_profile" "dev" {
  tenant_dn  = aci_tenant.dev.id
  name       = "${var.prefix}_ap"
  annotation = local.annotation
}

resource "aci_vrf" "dev" {
  tenant_dn  = aci_tenant.dev.id
  name       = "${var.prefix}_vrf"
  annotation = local.annotation
}