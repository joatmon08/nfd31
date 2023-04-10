# data "http" "nso" {
#   url      = "https://${var.switch}:${var.switch_http_port}/restconf/data/tailf-ncs:devices/device=${var.switch_hostname}"
#   insecure = true

#   # Optional request headers
#   request_headers = {
#     Authorization = "Basic ${base64encode("${var.switch_user}:${var.switch_password}")}"
#     Accept        = "application/yang-data+json"
#   }
# }

# locals {
#   rtr_management_int = jsondecode(data.http.nso.response_body)["tailf-ncs:device"][0]["config"]["tailf-ned-cisco-ios:interface"]["GigabitEthernet"]
#   rtr_management_ip  = [for i in local.rtr_management_int : i.ip.address.primary.address if i.name == "1"]
# }

# output "debug_router_management_ip" {
#   value = local.rtr_management_ip
# }

# resource "terraform_data" "switch" {
#   triggers_replace = [local.rtr_management_ip]

#   connection {
#     host     = var.switch
#     user     = var.switch_user
#     password = var.switch_password
#     port     = var.switch_ssh_port
#   }

#   provisioner "file" {
#     content     = one(local.rtr_management_ip)
#     destination = "/tmp/device"
#   }

#   provisioner "file" {
#     content     = "show running-config"
#     destination = "/tmp/script"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cat /tmp/device",
#       "ncs_cli -C -n -u developer /tmp/script",
#     ]
#   }
# }

