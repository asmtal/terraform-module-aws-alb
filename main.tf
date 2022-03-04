locals {
  module_name          = "aws-alb"
  computed_module_name = var.parent_terraform_module != null ? "${var.parent_terraform_module}/${local.module_name}" : local.module_name
  alb_name             = "${var.identity.project}-${var.context}-${var.identity.environment}"
  tags                 = merge({
    TerraformModule = local.computed_module_name
  }, var.tags)
  listener_ssl_policy_default = "ELBSecurityPolicy-2016-08"
}

resource "aws_lb" "this" {
  count = var.enabled ? 1 : 0
  # max 32
  name  = local.alb_name

  load_balancer_type         = var.load_balancer_type
  internal                   = var.internal
  security_groups            = var.security_groups
  subnets                    = var.subnets
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  ip_address_type            = var.ip_address_type
  drop_invalid_header_fields = var.drop_invalid_header_fields
  enable_waf_fail_open       = var.enable_waf_fail_open
  desync_mitigation_mode     = var.desync_mitigation_mode

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = lookup(access_logs.value, "enabled", lookup(access_logs.value, "bucket", null) != null)
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  dynamic "timeouts" {
    for_each = length(keys(var.timeouts)) == 0 ? [] : [var.timeouts]

    content {
      create = lookup(timeouts.value, "create", "10m")
      update = lookup(timeouts.value, "update", "10m")
      delete = lookup(timeouts.value, "delete", "10m")
    }
  }
  tags = local.tags
}

resource "aws_lb_listener" "listener" {
  count = var.enabled ? length(var.listeners) : 0

  load_balancer_arn = join("", aws_lb.this.*.arn)

  port            = lookup(var.listeners[count.index], "port", null)
  protocol        = lookup(var.listeners[count.index], "protocol", "HTTPS")
  certificate_arn = lookup(var.listeners[count.index], "certificate_arn", null)
  ssl_policy      = lookup(var.listeners[count.index], "ssl_policy", local.listener_ssl_policy_default)
  alpn_policy     = lookup(var.listeners[count.index], "alpn_policy", null)

  dynamic "default_action" {
    for_each = length(keys(var.listeners[count.index])) == 0 ? [] : [
      var.listeners[count.index]
    ]

    # Defaults to forward action if action_type not specified
    content {
      type = lookup(default_action.value, "action_type", "forward")
      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [
          lookup(default_action.value, "redirect", {})
        ]

        content {
          path        = lookup(redirect.value, "path", null)
          host        = lookup(redirect.value, "host", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }

      dynamic "fixed_response" {
        for_each = length(keys(lookup(default_action.value, "fixed_response", {}))) == 0 ? [] : [
          lookup(default_action.value, "fixed_response", {})
        ]

        content {
          content_type = fixed_response.value["content_type"]
          message_body = lookup(fixed_response.value, "message_body", null)
          status_code  = lookup(fixed_response.value, "status_code", null)
        }
      }

    }
  }
  tags = merge(
    local.tags,
    lookup(var.listeners[count.index], "tags", {})
  )
}

