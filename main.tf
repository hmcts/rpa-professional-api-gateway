locals {
  name                  = "professional-api-${var.env}"
  platform_api_papi_sku = "${var.env == "prod" ? "Premium" : "Developer"}"
  
}

data "template_file" "papi_template" {
  template = "${file("${path.module}/templates/professional-api-management.json")}"
}

resource "azurerm_subnet" "api-papi-subnet" {
  name                 = "core-infra-subnet-papi-${var.env}"
  resource_group_name  = "${var.vnet_rg_name}"
  virtual_network_name = "${var.vnet_name}"
  address_prefix       = "${cidrsubnet("${var.source_range}", 4, var.source_range_index)}"

  lifecycle {
    ignore_changes     = "address_prefix"
  }
}

resource "azurerm_template_deployment" "papi-managment" {
  template_body       = "${data.template_file.papi_template.rendered}"
  name                = "${local.name}"
  resource_group_name = "${var.vnet_rg_name}"
  deployment_mode     = "Incremental"

  parameters = {
    location                           = "${var.location}"
    publisher_email                    = "${var.publisher_email}"
    publisher_name                     = "${var.publisher_name}"
    notification_sender_email          = "${var.notification_sender_email}"
    env                                = "${var.env}"
    platform_papi_name                 = "${local.name}"
    platform_papi_subnetResourceId     = "${azurerm_subnet.api-papi-subnet.id}"
    platform_papi_sku                  = "${local.platform_api_papi_sku}"
  }
}