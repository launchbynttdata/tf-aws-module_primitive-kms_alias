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

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))

  default = {
    key = {
      name       = "key"
      max_length = 64
    }
    key_alias = {
      name       = "alias"
      max_length = 64
    }
  }
}

variable "logical_product_family" {
  description = "The logical product family for the resource names."
  type        = string
  default     = "key"
}

variable "logical_product_service" {
  description = "The logical product service for the resource names."
  type        = string
  default     = "alias"
}

variable "region" {
  description = "The AWS region for the resource names."
  type        = string
  default     = "us-west-2"
}
variable "class_env" {
  description = "The class environment for the resource names."
  type        = string
  default     = "dev"
}

variable "instance_env" {
  description = "The instance environment for the resource names."
  type        = string
  default     = "000"
}

variable "instance_resource" {
  description = "The instance resource for the resource names."
  type        = string
  default     = "000"
}

variable "enable_key_rotation" {
  description = "Whether to enable key rotation for the KMS key."
  type        = bool
  default     = true
}
