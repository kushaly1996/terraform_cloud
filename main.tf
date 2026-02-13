data "tfe_organization" "my_org" {
  name = "kushal_devops"
}

data "tfe_oauth_client" "client" {
  organization = data.tfe_organization.my_org.name
  name         = var.oauth_name
}

resource "tfe_workspace" "parent" {
  name           = "my-test-workspace"
  organization   = data.tfe_organization.my_org.name
  queue_all_runs = false
  vcs_repo {
    branch         = "main"
    identifier     = "kushaly1996/test_terraform_cloud"
    oauth_token_id = "ot-ewrzLDu5kcjzVFgU"
  }
}