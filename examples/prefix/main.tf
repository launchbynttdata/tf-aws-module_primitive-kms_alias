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
  # checkov:skip=CKV_TF_1: trusted module source
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.region
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  maximum_length          = each.value.max_length
  instance_resource       = var.instance_resource
}

module "kms_key" {
  # checkov:skip=CKV_TF_1: trusted module source
  source                  = "terraform.registry.launch.nttdata.com/module_primitive/kms_key/aws"
  version                 = "~> 0.1"
  deletion_window_in_days = null
  description             = "KMS Key for simple example"
  enable_key_rotation     = var.enable_key_rotation
}

module "kms_alias" {
  source = "../.."

  name_prefix   = module.resource_names["key_alias"].minimal_random_suffix_without_any_separators
  target_key_id = module.kms_key.key_id
}
