variable "azure_app_name" {
  description = "Name for the Azure application"
  type        = string
  default     = "github"
}

variable "github_repository" {
  description = "GitHub repository including the organisation ex: octo/octo-repo"
  type        = string
}

variable "github_repository_branch" {
  description = "GitHub repository branch which Terraform apply changes"
  type        = string
  default     = "main"
}

variable "github_repository_environment" {
  description = "GitHub repository environment which Terraform apply changes"
  type        = string
  default     = "prod"
}