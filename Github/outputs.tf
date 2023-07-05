output "Repository" {
  value = "${github_repository.repository}"
}

output "current_github_login" {
  value = "${data.github_user.current.login}"
}