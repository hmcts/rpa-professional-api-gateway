locals {
  name                  = "rpa-professional-api-portal-${var.env}"
  platform_api_papi_sku = "${var.env == "prod" ? "Premium" : "Developer"}"
}


data "azurerm_key_vault" "key_vault" {
    name = "${local.shared_vault_name}"
    resource_group_name = "${local.shared_vault_name}"
}

data "azurerm_key_vault_secret" "oauth2_client" {
    name = "papi-oauth2-client-id"
    vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
}

data "azurerm_key_vault_secret" "oauth2_secret" {
    name = "papi-oauth2-client-key"
    vault_uri = "${data.azurerm_key_vault.key_vault.vault_uri}"
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
    location                                   = "${var.location}"
    publisher_email                            = "${var.publisher_email}"
    env                                        = "${var.env}"
    platform_papi_name                         = "${local.name}"
    platform_papi_infra           			   = "core-infra-${var.env}"
    platform_papi_vnet           			   = "core-infra-vnet-${var.env}"
    platform_papi_snet   	        		   = "core-infra-subnet-apimgmt-${var.env}"
    subscription_id                            = "${var.subscription_id}"
    platform_papi_sku                          = "${local.platform_api_papi_sku}"
    oauth_token_endpoint                       = "${var.oauth_token_endpoint}"
    oauth_authorization_endpoint_redirect_uri  = "${var.oauth_authorization_endpoint_redirect_uri}"
    oauth_client_registration_endpoint         = "${var.oauth_client_registration_endpoint}"
    oauth_authorization_endpoint               = "${var.oauth_authorization_endpoint}"
    oauth_client_id                            = "${data.azurerm_key_vault_secret.oauth2_client.value}"
    oauth_client_secret                        = "${data.azurerm_key_vault_secret.oauth2_secret.value}"
  }
}