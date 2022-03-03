locals {
  module_name          = "aws-alb"
  computed_module_name = var.parent_terraform_module != null ? "${var.parent_terraform_module}/${local.module_name}" : local.module_name
  secret_name          = "/${var.identity.project}-${var.identity.environment}/${var.context}"
  tags = merge({
    TerraformModule = local.computed_module_name
  }, var.tags)
  # fixed params start - not allowed to be changed
  # fixed params end - not allowed to be changed
}

