terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.3.0"
    }
  }
}

provider "nsxt" {
  host                 = "s-bi-nsxmgr1.brisk-it.net"
  username             = "sa_nsx_tf@brisk-it.net"
  allow_unverified_ssl = true
  max_retries          = 2
}

data "nsxt_policy_tier0_gateway" "T0" {
  display_name = "T0-GW"
}

data "nsxt_policy_transport_zone" "tz_overlay" {
  display_name = "TZ-OVERLAY"
}

data "nsxt_policy_transport_zone" "tz_vlan" {
  display_name = "TZ-VLAN"
}

resource "nsxt_policy_tier1_gateway" "T1-EXPLORE" {
  description               = "Tier 1 DEMO for VMware Explore 2024"
  display_name              = "T1-EXPLORE"
  failover_mode             = "PREEMPTIVE"
  default_rule_logging      = "true"
  tier0_path                = data.nsxt_policy_tier0_gateway.T0.path
  route_advertisement_types = ["TIER1_STATIC_ROUTES"]
  pool_allocation           = "ROUTING"
}

resource "nsxt_policy_segment" "LS-EXPLORE-01" {
  display_name        = "LS-EXPLORE-1"
  connectivity_path   = nsxt_policy_tier1_gateway.T1-EXPLORE.path
  transport_zone_path = data.nsxt_policy_transport_zone.tz_overlay.path
  subnet {
    cidr = "172.16.101.1/24"
  }
}