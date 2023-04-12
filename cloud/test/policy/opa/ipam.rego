package terraform.policies.ipam

import input.plan as tfplan

deny {
  aws_range := "10.255.0.0/16"
  r := tfplan.planned_values.root_module.child_modules[0].resources[_]
  r.type == "aws_vpc"
  r.values.address == "10.0.0.0"
  # net.cidr_contains(aws_range, r.change.after.cidr_block)
  # msg := sprintf("%v not in allocated range %v for AWS", [r.address, aws_range])
}

# deny {
#   azure_range := "10.252.0.0/16"
#   r := tfplan.resource_changes[_]
#   r.type == "azurerm_vnet"
#   net.cidr_contains(azure_range, r.change.after.cidr_block)
#   # msg := sprintf("%v not in allocated range %v for Azure", [r.address, azure_range])
# }