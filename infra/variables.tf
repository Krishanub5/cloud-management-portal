


variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network to be created"
}

variable "vnet_address_space" {
  type        = string
  description = "CIDR block for the Virtual Network"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where VNet will be created"
}

variable "env" {
  type        = string
  description = "Environment tag (e.g. dev, prod)"
}
