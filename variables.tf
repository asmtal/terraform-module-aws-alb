variable "identity" {
  description = <<-EOT
Unique project identity object:
```
*project* - Unique project identifier across entire organization.
environment - Name of environment. Possible values: dev[1-9]+, test[1-9]+, qa[1-9]+, green[1-9]+, blue[1-9]+, stage[1-9]+, uat[1-9]+, prod[1-9]+.
project_repo - Name of project repository which uses this module.
```
EOT
  type        = object({
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
  description = "Context of module usage. Will be used as name/id in all created resources. Min 2, Max 14 characters. E.g. `backend`, `frontend` etc."
  validation {
    condition     = length(var.context) >= 2 && length(var.context) <= 14
    error_message = "The `context` variable length must be between 2 and 14 characters."
  }
}

variable "enabled" {
  description = "Indicates whether all resources inside module should be created (affects nearly all resources)."
  type        = bool
  default     = true
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

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = false
}

variable "subnets" {
  description = "(Optional) A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value for load balancers of type network will force a recreation of the resource. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']."
  type        = list(string)
  default     = null
}
variable "idle_timeout" {
  description = "(Optional) The time in seconds that the connection is allowed to be idle. Defaults to `60`."
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "(Optional)  If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "(Optional) Indicates whether HTTP/2 is enabled in application load balancers. Defaults to true."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`"
  type        = string
  default     = "ipv4"
  validation {
    condition = contains([
      "ipv4", "dualstack"
    ], var.ip_address_type)
    error_message = "Allowed values for engine are  \"ipv4\", or \"dualstack\"."
  }
}

variable "drop_invalid_header_fields" {
  description = "(Optional) Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. Only valid for Load Balancers of type application. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enable_waf_fail_open" {
  description = "(Optional) Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. Defaults to false."
  type        = bool
  default     = false
}

variable "desync_mitigation_mode" {
  description = "(Optional) Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are `monitor`, `defensive` (default), `strictest`."
  type        = string
  default     = "defensive"
  validation {
    condition = contains([
      "monitor", "defensive", "strictest"
    ], var.desync_mitigation_mode)
    error_message = "Allowed values for engine are  \"monitor\", \"defensive\", or \"strictest\"."
  }
}

variable "access_logs" {
  description = <<-EOT
  (Optional) An Access Logs block. Support the following:
```
**bucket** - (Required) The S3 bucket name to store the logs in.
**prefix** - (Optional) The S3 bucket prefix. Logs are stored in the root if not configured.
**enabled** - (Optional) Boolean to enable / disable access_logs. Defaults to false, even when bucket is specified.
```
EOT
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = <<-EOT
  (Optional) Load balancer timeout block. Support the following:
```
create - (Default 10 minutes) Used for Creating LB
update - (Default 10 minutes) Used for LB modifications
delete - (Default 10 minutes) Used for destroying LB
```
EOT
  type        = map(string)
  default     = {}
}

variable "load_balancer_type" {
  description = "(Optional) The type of load balancer to create. Possible values are application, gateway, or network. The default value is `application`."
  type        = string
  default     = "application"
  validation {
    condition = contains([
      "application", "gateway", "network"
    ], var.load_balancer_type)
    error_message = "Allowed values for engine are  \"application\", \"gateway\", or \"network\"."
  }
}

variable "security_groups" {
  description = " (Optional) A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application. e.g. [\"sg-edcd9784\",\"sg-edcd9785\"]"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
  default     = null
}



variable "listeners" {
  description = "A list of maps describing the listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default = []
}
