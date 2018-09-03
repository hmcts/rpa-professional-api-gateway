locals {
  name                  = "rpa-professional-api-portal-${var.env}"
  platform_api_papi_sku = "${var.env == "prod" ? "Premium" : "Developer"}"
  
}

# Make sure the resource group exists
resource "azurerm_resource_group" "rg" {
  name     = "rpa-professional-api-${var.env}"
  location = "${var.location}"
}

data "template_file" "papi_template" {
  template = "${file("${path.module}/templates/professional-api-management.json")}"
}

resource "azurerm_template_deployment" "papi-managment" {
  template_body       = "${data.template_file.papi_template.rendered}"
  name                = "${local.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  deployment_mode     = "Incremental"

  parameters = {
    location                           = "${var.location}"
    publisher_email                    = "${var.publisher_email}"
    publisher_name                     = "${var.publisher_name}"
    env                                = "${var.env}"
    platform_papi_name                 = "${local.name}"
    platform_papi_sku                  = "${local.platform_api_papi_sku}"
  }
}