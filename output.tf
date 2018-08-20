output "host_name" {
  value = "${azurerm_template_deployment.papi-managment.name}.azure-api.net"
}

output "developer_portal_url" {
  value = "${azurerm_template_deployment.papi-managment.name}.portal.azure-api.net"
}