locals {
  # Get a list of all yaml files in a specific directory
  all_tenants_raw = [for x in fileset(path.module, "tenants/*.yaml") : yamldecode(file(x))]
  all_tenants     = { for x in local.all_tenants_raw : x.name => x }

}

output "all_tnants" {
  value = local.all_tenants
}

data "tfe_organization" "my_org" {
  name = "kushal_devops"
}

data "tfe_oauth_client" "client" {
  organization = data.tfe_organization.my_org.name
  name         = var.oauth_name ## oauth_name = "kushal-github-oauth"
}

resource "tfe_workspace" "parent" {
  for_each       = local.all_tenants
  name           = "my-${each.value.name}"
  organization   = data.tfe_organization.my_org.name
  queue_all_runs = false
  vcs_repo {
    branch         = "main"
    identifier     = "kushaly1996/tfws-tenant-harness"
    oauth_token_id = var.oauth_token_id #"ot-ewrzLDu5kcjzVFgU"
  }
}

resource "tfe_variable" "name" {
  for_each     = local.all_tenants
  key          = "tenant_name"
  value        = each.value.name
  category     = "terraform"
  workspace_id = tfe_workspace.parent[each.key].id
  description  = "a useful description"
}

# account id and api token of harness to create harness resources

resource "tfe_variable" "harness_account_id" {
  for_each     = local.all_tenants
  key          = "account_id"
  value        = var.account_id
  category     = "terraform"
  workspace_id = tfe_workspace.parent[each.key].id
  description  = "a useful description"
}

resource "tfe_variable" "harness_platform_api_key" {
  for_each     = local.all_tenants
  key          = "platform_api_key"
  value        = var.platform_api_key
  category     = "terraform"
  workspace_id = tfe_workspace.parent[each.key].id
  description  = "a useful description"
}
