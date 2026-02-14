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

data "github_repository" "this" {
  name = var.github_repository
}

data "github_team" "dp" {
  slug = "Data-Platform"
}

data "github_team" "dp_de" {
  slug = "Data-Platform-DE"
}

data "github_team" "dp_po" {
  slug = "Data-Platform-PO"
}

data "github_user" "current" {
  username = "whichwit"
}

data "github_users" "managers" {
  usernames = ["whichwit"]
}