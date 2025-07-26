variable "subscription_display_name" {
  type        = string
  description = "Display name for the new subscription"
}

variable "management_group_id" {
  type        = string
  description = "Target management group ID"
}

variable "environment" {
  type        = string
  description = "Environment tag (dev/uat/prod)"
}

variable "cost_center" {
  type        = string
  description = "Cost center tag"
}

variable "purpose" {
  type        = string
  description = "Purpose of the subscription"
}

variable "requested_by" {
  type        = string
  description = "Requestor identity"
}
