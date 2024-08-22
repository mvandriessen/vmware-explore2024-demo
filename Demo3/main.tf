# Loading services module
module "services" {
  source  = "app.terraform.io/brisk-it/services/nsxt"
  version = "1.0.0"
  map_svc = var.map_svc
}

#Loading groups module
module "groups" {
  source  = "app.terraform.io/brisk-it/groups/nsxt"
  version = "1.0.0"
  map_grp = var.map_grp
}

data "nsxt_policy_service" "bltin" {
  for_each     = toset(var.map_services_bltin["SERVICES"])
  display_name = each.key
}

data "nsxt_policy_group" "ext" {
  for_each     = toset(var.map_groups_ext["GROUPS"])
  display_name = each.key
}

#Loading policy module
module "policy" {
  source  = "app.terraform.io/brisk-it/policy/nsxt"
  version = "2.0.0"
  map_policies = var.map_policies
  #Other variable in the group and service root modules
  nsxt_policy_grp_grp   = module.groups.grp
  nsxt_policy_svc_svc   = module.services.svc
  nsxt_policy_svc_bltin = data.nsxt_policy_service.bltin
  nsxt_policy_grp_ext   = data.nsxt_policy_group.ext
}