module "explore-segment" {
  for_each = var.segments_native
  source  = "app.terraform.io/brisk-it/nsx-module/explore2024"
  version = "0.0.1"
  # insert required variables here

  location     = var.location
  number       = each.value.number
  segment_cidr = each.value.cidr
}