# ------------------------------------------------------------------------------
# Container Definitions
# ------------------------------------------------------------------------------

locals {
  # Ethereum Indexer API
  api_def = templatefile("${path.module}/templates/container-definition-api.json", {
    CONTAINER_NAME = local.api_task_name
    ESSENTIAL      = var.api_is_essential
    IMAGE_URL      = var.api_image_registry_url
    IMAGE_VERSION  = var.api_image_version
    CONTAINER_PORT = var.api_container_port
    MEMORY         = var.api_container_memory_alloc
    CPU            = var.api_container_cpu_alloc
    CLUSTER_NAME   = local.cluster_name
    AWS_REGION     = var.aws_region
    ENV_VARS = jsonencode(concat(
      var.api_environment_vars
    ))
  })
}
