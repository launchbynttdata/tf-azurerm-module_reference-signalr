locals {
  default_tags = {
    "provisioner" = "Terraform"
  }
  tags = merge(local.default_tags, var.tags)

  resource_group_name = module.resource_names["resource_group"].standard
  signalr_name        = module.resource_names["signalr"].standard

}
