terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

# Configure the GitHub provider
provider "github" {
  # The token will be sourced from GITHUB_TOKEN environment variable in the workflow
}

# Data source to fetch the current repository details
data "github_repository" "current" {
  full_name = "gatest" # Replace with your repository full name
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