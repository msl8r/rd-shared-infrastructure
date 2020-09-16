locals {
  servicebus_namespace_name       = "${var.product}-servicebus-${var.env}"
  caseworker_topic_name           = "${var.product}-caseworker-topic-${var.env}"
  subscription_name               = "${var.product}-caseworker-subscription-${var.env}"
  resource_group_name             = "${azurerm_resource_group.rg.name}"
}

module "servicebus-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${local.servicebus_namespace_name}"
  location            = "${var.location}"
  env                 = "${var.env}"
  common_tags         = "${local.common_tags}"
  resource_group_name = "${local.resource_group_name}"
}

module "caseworker-topic" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                  = "${local.caseworker_topic_name}"
  namespace_name        = "${module.servicebus-namespace.name}"
  resource_group_name   = "${local.resource_group_name}"
}

module "caseworker-subscription" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                  = "${local.subscription_name}"
  namespace_name        = "${module.servicebus-namespace.name}"
  topic_name            = "${module.caseworker-topic.name}"
  resource_group_name   = "${local.resource_group_name}"
}