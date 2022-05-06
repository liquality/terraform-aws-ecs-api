locals {
  cluster_name        = "chain-indexer-${var.api_name}"
  api_service_name    = "indexer-api-${var.api_name}"
  api_task_name       = "${var.api_task_name}-${var.api_name}"
  route53_record_name = "${var.route53_record_name_prefix}${var.api_name}"
  vpc_workspace_name  = "aws-networking-infra-${var.env_alias}"
}

locals {
  tags = {
    environment   = var.env_alias
    chain_service = "chain-indexer"
    chain_network = var.api_name
  }
}
