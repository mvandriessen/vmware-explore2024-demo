map_grp = {
  ######### IP GROUPS ##############

  ######### GLOBAL GROUPS ##############

  grp_aad                         = { TAG = ["AAD"] }
  grp_activeiq                    = { TAG = ["ACTIVEIQ"] }
  grp_ad                          = { TAG = ["AD"] }
  grp_ad_ca                       = { TAG = ["AD", "CA"] }
  grp_ad_ca_vip                   = { IP = ["172.16.202.4"] }
  grp_ad_dc                       = { TAG = ["AD", "DC", "ITGLO"] }
  grp_ad_kms                      = { TAG = ["AD", "KMS"] }
  grp_dfs                         = { TAG = ["DFS"] }
  grp_exchange                    = { TAG = ["EXCHANGE"], IP = ["172.16.202.6", "172.16.202.104"] }
  grp_sql                         = { TAG = ["SQL"] }


}

map_svc = {
  svc_AAD             = { TCP = ["135", "49182", "54890", "54915"] }
  svc_AD              = { TCP = ["53", "88", "123", "135", "137", "139", "389", "445", "464", "636", "3268", "3269", "9389", "49125-65535"], UDP = ["53", "88", "123", "137", "389"] }
  svc_CA              = { TCP = ["80", "56880"] }
  tcp_515             = { TCP = ["515"] }
  tcp_1194            = { TCP = ["1194"] }
  tcp_1688            = { TCP = ["1688"] }
}



map_services_bltin = {
  SERVICES = ["ICMP ALL", "SSH", "HTTPS", "Syslog-Server-UDP", "Syslog-Server", "DHCP-Server", "DHCP-Client", "NTP", "HTTP", "MS-SQL-S", "RDP", "ICMP Echo Request", "MS-DS", "LDAP", "MS_RPC_TCP", "SNMP"]
}

map_groups_ext = {
  GROUPS = []
}


map_policies = {
  ########################
  #### INFRASTRUCTURE ####
  ########################
  ICMP = {
    category        = "Infrastructure"
    sequence_number = "7"
    scope           = []
    rules = [
      {
        display             = "Allow ICMP Echo"
        sources             = []
        sources_negate      = false
        destinations        = []
        destinations_negate = false
        services            = ["ICMP Echo Request"]
        scope               = []
        action              = "ALLOW"
        disabled            = "false"
        logged              = "true"
        direction           = "IN_OUT"
      }
    ]
  },
  DOMAIN = {
    category        = "Infrastructure"
    sequence_number = "12"
    scope           = ["grp_ad"]
    rules = [
      {
        display             = "AD Services to DC"
        sources             = []
        sources_negate      = false
        destinations        = ["grp_ad_dc"]
        destinations_negate = false
        services            = ["svc_AD"]
        scope               = ["grp_ad_dc"]
        action              = "ALLOW"
        disabled            = "false"
        logged              = "true"
        direction           = "IN"
      },
      {
        display             = "HTTP to PKI VIP"
        sources             = []
        sources_negate      = false
        destinations        = ["grp_ad_ca_vip"]
        destinations_negate = false
        services            = ["HTTP"]
        scope               = []
        action              = "ALLOW"
        disabled            = "false"
        logged              = "true"
        direction           = "IN"
      },
      {
        display             = "Any to CA"
        sources             = []
        sources_negate      = false
        destinations        = ["grp_ad_ca"]
        destinations_negate = false
        services            = ["svc_CA", "MS_RPC_TCP"]
        scope               = ["grp_ad_ca"]
        action              = "ALLOW"
        disabled            = "false"
        logged              = "true"
        direction           = "IN"
      },
      {
        display             = "Any to KMS"
        sources             = []
        sources_negate      = false
        destinations        = ["grp_ad_kms"]
        destinations_negate = false
        services            = ["tcp_1688"]
        scope               = ["grp_ad_kms"]
        action              = "ALLOW"
        disabled            = "false"
        logged              = "true"
        direction           = "IN"
      },
      {
        display             = "Catch all - REMOVED WHEN NO HITS"
        sources             = []
        sources_negate      = false
        destinations        = []
        destinations_negate = false
        services            = []
        scope               = ["grp_ad"]
        action              = "ALLOW"
        disabled            = "false"
        logged              = "true"
        direction           = "IN"
      }
    ]
  },
  DFS = {
    category        = "Infrastructure"
    sequence_number = "31"
    scope           = ["grp_dfs"]
    rules = [
      {
        display             = "Incoming SMB to DFS"
        sources             = []
        sources_negate      = false
        destinations        = ["grp_dfs"]
        destinations_negate = false
        services            = ["MS-DS"]
        scope               = ["grp_dfs"]
        action              = "ALLOW"
        disabled            = "false"
        logged              = "true"
        direction           = "IN"
      },
      {
        display             = "Default drop - DFS"
        sources             = []
        sources_negate      = false
        destinations        = ["grp_dfs"]
        destinations_negate = false
        services            = []
        scope               = ["grp_dfs"]
        action              = "DROP"
        disabled            = "false"
        logged              = "true"
        direction           = "IN"
      }
    ]
  },
}
