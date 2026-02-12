

# Create a 'staging' environment
resource "github_repository_environment" "staging" {
  repository = github_repository.next.name
  environment = "staging"
  # Optional: add deployment branch policies or wait timers
  deployment_branch_policy {
    protected_branches = true
      custom_branch_policies = true
  }

  reviewers {
    teams = [data.github_team.dp_reviewers.id]
  }
}

resource "github_repository_environment_deployment_policy" "staging" {
  repository     = github_repository.next.name
  environment    = github_repository_environment.staging.environment
  branch_pattern = "develop"
}

# Optional: Add an environment secret or variable
resource "github_actions_environment_variable" "example_variable" {
  repository    = github_repository.next.name
  environment   = github_repository_environment.staging.environment
  variable_name = "EXAMPLE_VAR"
  value         = "example_value"
}