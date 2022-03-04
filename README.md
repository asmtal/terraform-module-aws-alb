# AWS Secrets Manager Terraform module

Terraform module which creates AWS Secrets Manager resources.

#### Table of Contents
2. [Available Features](#available-features)
2. [TODO](#available-features)
3. [Using pre-commit locally](#using-pre-commit-locally)
4. [Usage](#usage)
5. [Requirements](#requirements)
6. [Providers](#Providers)
7. [Inputs](#inputs)
8. [Outputs](#outputs)

## Available Features

## TODO


## Using pre-commit locally
https://github.com/antonbabenko/pre-commit-terraform#how-to-install

## Usage
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | (Optional) An Access Logs block. Support the following:<pre>**bucket** - (Required) The S3 bucket name to store the logs in.<br>**prefix** - (Optional) The S3 bucket prefix. Logs are stored in the root if not configured.<br>**enabled** - (Optional) Boolean to enable / disable access_logs. Defaults to false, even when bucket is specified.</pre> | `map(string)` | `{}` | no |
| <a name="input_context"></a> [context](#input\_context) | Context of module usage. Will be used as name/id in all created resources. Min 2, Max 14 characters. E.g. `backend`, `frontend` etc. | `string` | n/a | yes |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | (Optional) Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are `monitor`, `defensive` (default), `strictest`. | `string` | `"defensive"` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | (Optional) Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. Only valid for Load Balancers of type application. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | (Optional)  If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | (Optional) Indicates whether HTTP/2 is enabled in application load balancers. Defaults to true. | `bool` | `true` | no |
| <a name="input_enable_waf_fail_open"></a> [enable\_waf\_fail\_open](#input\_enable\_waf\_fail\_open) | (Optional) Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. Defaults to false. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Indicates whether all resources inside module should be created (affects nearly all resources). | `bool` | `true` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Unique project identity object:<pre>*project* - Unique project identifier across entire organization.<br>environment - Name of environment. Possible values: dev[1-9]+, test[1-9]+, qa[1-9]+, green[1-9]+, blue[1-9]+, stage[1-9]+, uat[1-9]+, prod[1-9]+.<br>project_repo - Name of project repository which uses this module.</pre> | <pre>object({<br>    project      = string<br>    environment  = string<br>    project_repo = string<br>  })</pre> | n/a | yes |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | (Optional) The time in seconds that the connection is allowed to be idle. Defaults to `60`. | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Boolean determining if the load balancer is internal or externally facing. | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | (Optional) The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack` | `string` | `"ipv4"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | (Optional) The type of load balancer to create. Possible values are application, gateway, or network. The default value is `application`. | `string` | `"application"` | no |
| <a name="input_parent_terraform_module"></a> [parent\_terraform\_module](#input\_parent\_terraform\_module) | (Optional) Name of parent terraform module. Used for tagging. | `string` | `null` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application. e.g. ["sg-edcd9784","sg-edcd9785"] | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Optional) A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value for load balancers of type network will force a recreation of the resource. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) Load balancer timeout block. Support the following:<pre>create - (Default 10 minutes) Used for Creating LB<br>update - (Default 10 minutes) Used for LB modifications<br>delete - (Default 10 minutes) Used for destroying LB</pre> | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
