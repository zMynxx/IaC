## Creating Repository ##
resource "github_repository" "repository" {
  name        = var.repoName
  description = var.repoDescription
  visibility = var.repoVisibility

  auto_init          = true
  gitignore_template = "Terraform"
  license_template   = "mit"
}

# Retrieve information about the currently authenticated user.
data "github_user" "current" {
  username = ""
}

## Creating Branches ##
resource "github_branch" "development" {
  repository = github_repository.repository.name
  branch     = "development"
}

resource "github_branch" "main" {
  repository = github_repository.repository.name
  branch     = "master"
}

resource "github_branch_default" "default"{
  repository = github_repository.repository.name
  branch     = github_branch.main.branch
}

# Configure a branch protection for the repository
resource "github_branch_protection" "repository" {
  repository_id     = github_repository.repository.name

  pattern          = "master"
  enforce_admins   = true
  allows_deletions = true

  depends_on = [github_branch.main, github_branch.development]
  # required_status_checks {
  #   strict   = false
  #   contexts = ["ci/travis"]
  # }

  # required_pull_request_reviews {
  #   dismiss_stale_reviews = true
  #   restrict_dismissals    = true
  #   dismissal_restrictions= [data.github_user.current.node_id]
  # }

  # push_restrictions = [data.github_user.current.node_id]
}

##################
## Commit files ##
##################
resource "github_repository_file" "file" {
  repository          = github_repository.repository.name
  branch              = "master"
  file                = "Hello-github.txt"
  content             = "Hello World!"
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

#############
## Actions ##
#############

## Secrets ##
resource "github_actions_secret" "secret" {
  repository       = github_repository.repository.name
  secret_name      = "example_secret_name"
  plaintext_value  = "Hello World!"#var.some_secret_string
}

## Recommended - encode (base64) and encrypt using public key ## 
data "github_actions_public_key" "public_key" {
  repository = github_repository.repository.name
}

# resource "github_actions_secret" "example_secret" {
#   repository       = "${github_repository.myrepo}"
#   secret_name      = "example_secret_name2"
#   encrypted_value  = "Encrypted Hello World!" #var.some_encrypted_secret_string
# }

## Variables ##
resource "github_actions_variable" "variable" {
  repository       = github_repository.repository.name
  variable_name    = "MyVar"
  value            = "1"
}