package network.policies

import input.plan as plan

deny[msg] {
  msg = sprintf("%v", r)
}

deny[msg] {
  r := plan.planned_values.root_module.resources[_]
  r.type == "aws_vpc"
  r.values.cidr_block == "10.0.0.0/0"
  net.cidr_contains("10.254.0.0/16", r.values.cidr_block)
  msg = sprintf("%v not in allocated AWS CIDR block", r.values.cidr_block)
}

deny[msg] {
  r := plan.planned_values.root_module.resources[_]
  r.type == "azurerm_virtual_network"
  net.cidr_contains("10.252.0.0/16", r.values.cidr_block)
  msg = sprintf("%v not in allocated Azure CIDR block", r.values.cidr_block)
}