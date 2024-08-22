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