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
    for env, variables in var.environment_variables : [
      for name, value in variables : {
        environment = env
        name        = name
        value       = value
      }
    ]
  ])
}

# ========== Create a 'development' environment
resource "github_repository_environment" "development" {
  repository  = data.github_repository.this.name
  environment = "development"

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "development" {
  repository     = data.github_repository.this.name
  environment    = github_repository_environment.development.environment
  branch_pattern = "develop"
}

# ========== Create a 'staging' environment
resource "github_repository_environment" "staging" {
  repository  = data.github_repository.this.name
  environment = "staging"

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }

  reviewers {
    teams = [data.github_team.dp.id]
  }
}

resource "github_repository_environment_deployment_policy" "staging" {
  repository     = data.github_repository.this.name
  environment    = github_repository_environment.staging.environment
  branch_pattern = "develop"
}


# ========== Create a 'production' environment

resource "github_repository_environment" "production" {
  repository          = data.github_repository.this.name
  environment         = "production"
  prevent_self_review = true

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }

  reviewers {
    users = [data.github_user.current.id]
    teams = [data.github_team.dp_po.id]
  }
}

resource "github_repository_environment_deployment_policy" "production" {
  repository     = data.github_repository.this.name
  environment    = github_repository_environment.production.environment
  branch_pattern = "develop"
}

# ========== Create environment secrets

resource "github_actions_environment_secret" "this" {
  for_each = {
    for pair in local.environment_secret_pairs : "${pair.environment}.${pair.name}" => pair
  }

  repository      = data.github_repository.this.name
  environment     = each.value.environment
  secret_name     = each.value.name
  plaintext_value = each.value.value

  depends_on = [
    github_repository_environment.development,
    github_repository_environment.staging,
    github_repository_environment.production
  ]
}

resource "github_actions_environment_variable" "this" {
  for_each = {
    for pair in local.environment_variable_pairs : "${pair.environment}.${pair.name}" => pair
  }

  repository    = data.github_repository.this.name
  environment   = each.value.environment
  variable_name = each.value.name
  value         = each.value.value

  depends_on = [
    github_repository_environment.development,
    github_repository_environment.staging,
    github_repository_environment.production
  ]
}
