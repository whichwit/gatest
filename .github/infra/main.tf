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
  token = var.github_token
  owner = "amsrun"
}

# Data source to fetch the current repository details


data "github_team" "dp_reviewers" {
  slug = "dp-reviewers"
}
