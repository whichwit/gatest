resource "github_repository" "next" {
  name = "${var.github_repository}" # Replace with your repository full name
  description = "This repository was created using Terraform and GitHub Actions"
  visibility = "public" # set to "private" for private repositories
  has_discussions = false
  has_projects = false
  has_wiki = false

  allow_squash_merge = true
  squash_merge_commit_title = "PR_TITLE"
  squash_merge_commit_message = "BLANK"

  allow_merge_commit = false
  allow_auto_merge = true
  allow_rebase_merge = false
  delete_branch_on_merge = true
  auto_init = false

}

# resource "github_branch" "develop" {
#   repository = github_repository.next.name
#   branch     = "develop"
# }

# resource "github_branch_default" "default"{
#   repository = github_repository.next.name
#   branch     = "develop"
#   rename     = true
# }