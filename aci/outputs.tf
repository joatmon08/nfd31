output "tenant" {
  value = aci_tenant.dev.name
}

output "app_profile" {
  value = aci_application_profile.dev.name
}

output "vrf" {
  value = aci_vrf.dev.name
}