variable "identity" {
  description = <<-EOT
Unique project identity object:
```
*project* - Unique project identifier across entire organization.
environment - Name of environment. Possible values: dev[1-9]+, test[1-9]+, qa[1-9]+, green[1-9]+, blue[1-9]+, stage[1-9]+, uat[1-9]+, prod[1-9]+.
project_repo - Name of project repository which uses this module.
```
EOT
  type = object({
    project      = string
    environment  = string
    project_repo = string
  })
  validation {
    condition = contains(flatten([
      for env_name in [
        "dev", "test", "qa", "green", "blue", "stage", "uat", "prod"
        ] : [
        for num in [
          "", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        ] : "${env_name}${num}"
      ]
    ]), var.identity.environment) && length(var.identity.project) >= 2 && length(var.identity.project) <= 10 && var.identity.project_repo != null
    error_message = "Value of 'environment' must be one of allowed values. Length of Variable 'project' must be between 2 and 10 characters. Value of 'project_repo' variable must not be null."
  }
}

variable "context" {
  type        = string
  description = "Context of module usage. Will be used as name/id in all created resources."
}

variable "enabled" {
  description = "Indicates whether all resources inside module should be created (affects nearly all resources)."
  type        = bool
  default     = true
}

variable "description" {
  description = "(Optional) Description of the secret."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "parent_terraform_module" {
  description = "(Optional) Name of parent terraform module. Used for tagging."
  type        = string
  default     = null
}
