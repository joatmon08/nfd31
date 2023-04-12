package terraform.policies.ipam

import input.plan as tfplan

deny[msg] {
  aws_range := "10.255.0.0/16"
  r := tfplan.planned_values.root_module.child_modules[0].resources[_]
  r.type == "aws_vpc"
  not net.cidr_contains(aws_range, r.values.cidr_block)
  msg := sprintf("%v not in allocated range %v for AWS", [r.address, aws_range])
}

deny[msg] {
  azure_range := "10.252.0.0/16"
  r := tfplan.planned_values.root_module.resources[_]
  r.type == "azurerm_virtual_network"
  not net.cidr_contains(azure_range, r.values.address_space[0])
  msg := sprintf("%v not in allocated range %v for Azure", [r.address, azure_range])
}