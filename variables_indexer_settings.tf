# ------------------------------------------------------------------------------
# Chain settings
# ------------------------------------------------------------------------------
variable "chain_network_name" {
  type        = string
  description = "A logical name for the chain network (e.g eth-ropsten, eth-rinkeby, rsk-mainnet)."
}

variable "chain_network_endpoint" {
  type        = string
  description = "The web3 uri for the blockchain network."
}
