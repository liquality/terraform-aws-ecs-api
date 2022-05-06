# terraform-aws-ecs-ethereum-indexer

Terraform module for Liquality's blockchain indexer services (AWS ECS).

## Table of Contents

* [Introduction][section-introduction]
* [Usage][section-usage]
* [Inputs][section-inputs]
* [Requirements][section-requirements]
* [Providers][section-providers]
* [License][section-license]


## Introduction

[TBC]


## Usage

Example of an RSK testnet configuration:

```
module "api_name" {
  source = "github.com/liquality/terraform-aws-ecs-api.git?ref=dev"

  # The target environment
  env_alias  = "chainhub"
  aws_region = "us-east-1"

  # DNS route53 settings
  route53_zone_name          = "api.liq-chainhub.net"
  route53_record_name_prefix = "dev-"

  # API settings
  api_image_version          = "latest"
  api_environment_vars       = []
  api_container_memory_alloc = 512
  api_container_cpu_alloc    = 256
  api_instance_count         = 2
  api_image_registry_url     = "ghcr.io/liquality/liquality-near-contract-helper"
  api_environment_vars = [
    { name = "START_BLOCK", value = 1397234 },
    { name = "MAX_BLOCK_BATCH_SIZE", value = 10 },
    { name = "MAX_TRANSACTION_BATCH_SIZE", value = 15 },
    { name = "REORG_GAP", value = 3 },
    { name = "BLOCKTIME", value = 1000 }
  ]
}
```


## Inputs

[TBC]


## Requirements

[TBC]


## Providers

| Name    | Version |
| ------- | ------- |
| aws     | >= 3.38 |


## License

[TBC]



[section-introduction]: #introduction
[section-usage]: #usage
[section-inputs]: #inputs
[section-requirements]: #requirements
[section-providers]: #providers
[section-license]: #license
