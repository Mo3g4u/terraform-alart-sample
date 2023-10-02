variable "region" {
  description = "AWS region"
  default     = "ap-northeast-1"
  type        = string
}

variable "project" {
  description = "project name"
  default     = "terraform-alart-sample"
  type        = string
}

variable "env" {
  description = "environment type"
  default     = "dev"
  type        = string
}

variable "security_group_ids" {
  description = "security group ids"
  type        = list(string)
}

variable "subnet_id" {
  description = "subnet id"
  type        = string
}
  