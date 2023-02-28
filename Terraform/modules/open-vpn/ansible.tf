# [Lior Dux] ==================== [ OpenVPN Access Server ] ====================  [24-02-2023] #
#
# Ansible set up for this module.
#

#############
## Ansible ##
#############
# Export Terraform variable values to an Ansible hosts
resource "local_file" "tf_ansible_vars_file_new" {
  content  = <<-DOC
    [servers]
    ${aws_eip.vpn_access_server.public_ip}
    DOC
  filename = "../Ansible/inventory/hosts_by_tf"
}

### OR - Run directly 
# provisioner "local-exec" {
#   command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook -u ${var.ssh_user} --private-key=\"~/.ssh/id_rsa\" --extra-vars='{"aws_subnet_id": ${aws_terraform_variable_here}, "aws_security_id": ${aws_terraform_variable_here} }' -i '${azurerm_public_ip.pnic.ip_address},' ansible/deploy-with-ansible.yml"
# }