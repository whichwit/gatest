terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

variable "github_token" {
  description = "GitHub token with repo and environment access."
  type        = string
  sensitive   = true
}

# Configure the GitHub provider
provider "github" {
  # The token will be sourced from GITHUB_TOKEN environment variable in the workflow
  token = var.github_token
}

# Data source to fetch the current repository details
data "github_repository" "current" {
  full_name = "amsrun/gatest" # Replace with your repository full name
}

# Create a 'staging' environment
resource "github_repository_environment" "staging" {
  repository = data.github_repository.current.name
  environment = "staging"
  # Optional: add deployment branch policies or wait timers
  deployment_branch_policy {
    protected_branches = true
    custom_branch_policies = false
  }
}

# Optional: Add an environment secret or variable
resource "github_actions_environment_variable" "example_variable" {
  repository    = data.github_repository.current.name
  environment   = github_repository_environment.staging.environment
  variable_name = "EXAMPLE_VAR"
  value         = "example_value"
}