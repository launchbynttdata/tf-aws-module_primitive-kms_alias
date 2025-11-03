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

output "kms_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the alias."
  value       = module.kms_alias.kms_alias_arn
}

output "target_key_arn" {
  description = "The ARN of the target KMS Key."
  value       = module.kms_alias.target_key_arn
}
