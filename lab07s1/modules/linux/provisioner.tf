# resource "null_resource" "linux_provisioner" {
#   count = var.nb_count
#   depends_on = [
#     azurerm_linux_virtual_machine.vmlinux,
#     azurerm_network_interface.linux_nic,
#   ]


#   provisioner "remote-exec" {
#     inline = [
#       "/usr/bin/hostname",
#     ]

#     connection {

#       type        = "ssh"
#       user        = var.Admin_user_name
#       private_key = file(var.priv_key)
#       # host = var.linux_name
#       host = element(azurerm_public_ip.linux_pip[*].fqdn, count.index + 1)
#       # host = element(azurerm_linux_virtual_machine.vmlinux[*].public_ip_addresses, count.index + 1 )



#     }



#   }

# }


resource "null_resource" "linux_provisioner" {

  for_each = var.linux_name

  depends_on = [

    azurerm_linux_virtual_machine.vmlinux,
    # azurerm_network_security_group.nsg

  ]

  provisioner "remote-exec" {

    inline = [

      "cat /proc/sys/kernel/hostname",
      # "sudo yum insall python3"

    ]

    connection {

      type = "ssh"

      user = var.Admin_user_name
      #    agent = true

      private_key = file(var.priv_key)
      timeout     = "45"

      host = azurerm_public_ip.linux_pip[each.key].fqdn


    }

  }

}