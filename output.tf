output "host_name" {
  value = "${module.papi-managment.name}.azure-api.net"
}

output "developer_portal_url" {
  value = "${module.papi-managment.name}.portal.azure-api.net"
}