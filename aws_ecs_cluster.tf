# ------------------------------------------------------------------------------
# Container Cluster (ECS)
# ------------------------------------------------------------------------------
resource "aws_ecs_cluster" "this" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = local.tags
}
