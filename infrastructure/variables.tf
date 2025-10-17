variable "environment" {
  description = "Environment name (e.g., production, staging)"
  type        = string
  default     = "production"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default     = "183295417701"
}

# GitHub Configuration
variable "github_repository_url" {
  description = "GitHub repository URL (e.g., https://github.com/username/repo)"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to deploy from"
  type        = string
  default     = "main"
}

variable "github_connection_arn" {
  description = "ARN of the AWS App Runner GitHub connection. Must be created manually in AWS Console first."
  type        = string
}

# Domain Configuration
variable "domain_name" {
  description = "Base domain name (www will be added automatically for App Runner)"
  type        = string
  default     = "riacademyofwine.com"
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
  default     = "Z01022013L6VCTW45YGJ5"
}

# App Runner Instance Configuration
variable "cpu" {
  description = "CPU units for App Runner instance (0.25 vCPU, 0.5 vCPU, 1 vCPU, 2 vCPU, 4 vCPU)"
  type        = string
  default     = "1 vCPU"
}

variable "memory" {
  description = "Memory for App Runner instance (0.5 GB, 1 GB, 2 GB, 3 GB, 4 GB, 6 GB, 8 GB, 10 GB, 12 GB)"
  type        = string
  default     = "2 GB"
}

# Auto Scaling Configuration
variable "max_concurrency" {
  description = "Maximum number of concurrent requests per instance"
  type        = number
  default     = 100
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

# Environment Variables
variable "environment_variables" {
  description = "Environment variables for the application"
  type        = map(string)
  default     = {}
}
