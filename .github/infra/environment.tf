locals {
  environment_secret_pairs = flatten([
    for env, secrets in var.environment_secrets : [
      for name, value in secrets : {
        environment = env
        name        = name
        value       = value
      }
    ]
  ])

  environment_variable_pairs = flatten([
    for env, secrets in var.environment_secrets : [
      for name, value in secrets : {
        environment = env
        name        = name
        value       = value
      }
    ]
  ])
}

# ========== Create a 'development' environment
resource "github_repository_environment" "development" {
  repository  = github_repository.next.name
  environment = "development"

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "development" {
  repository     = github_repository.next.name
  environment    = github_repository_environment.development.environment
  branch_pattern = "develop"
}

# ========== Create a 'staging' environment
resource "github_repository_environment" "staging" {
  repository  = github_repository.next.name
  environment = "staging"

  deployment_branch_policy {
    protected_branches     = false
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


# ========== Create a 'production' environment

resource "github_repository_environment" "production" {
  repository          = github_repository.next.name
  environment         = "production"
  prevent_self_review = true

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }

  reviewers {
    users = [data.github_user.current.id]
    teams = [data.github_team.dp_reviewers.id]
  }
}

resource "github_repository_environment_deployment_policy" "production" {
  repository     = github_repository.next.name
  environment    = github_repository_environment.production.environment
  branch_pattern = "develop"
}

# ========== Create environment secrets

resource "github_actions_environment_secret" "this" {
  for_each = {
    for pair in local.environment_secret_pairs : "${pair.environment}.${pair.name}" => pair
  }

  repository      = github_repository.next.name
  environment     = each.value.environment
  secret_name     = each.value.name
  plaintext_value = each.value.value
}

resource "github_actions_environment_variable" "this" {
  for_each = {
    for pair in local.environment_variable_pairs : "${pair.environment}.${pair.name}" => pair
  }

  repository      = github_repository.next.name
  environment     = each.value.environment
  variable_name   = each.value.name
  value          = each.value.value
}

# Optional: Add an environment secret or variable
# resource "github_actions_environment_variable" "example_variable" {
#   repository    = github_repository.next.name
#   environment   = github_repository_environment.staging.environment
#   variable_name = "EXAMPLE_VAR"
#   value         = "example_value"
# }
