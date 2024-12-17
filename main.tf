// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.signalr_location))
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.environment_number
  instance_resource       = var.resource_number
  maximum_length          = each.value.max_length
  logical_product_family  = var.product_family
  logical_product_service = var.product_service
  use_azure_region_abbr   = true
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = module.resource_names["resource_group"].standard
  location = var.signalr_location

  tags = merge(var.tags, { resource_name = module.resource_names["resource_group"].standard })
}

module "signalr" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-signalr.git?ref=feature/init"

  signalr_location    = var.signalr_location
  resource_group_name = module.resource_group.name
  signalr_name        = module.resource_names["signalr"].standard
  tags                = merge(var.tags, { resource_name = module.resource_names["signalr"].standard })
  depends_on          = [module.resource_group]
}
