variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}
variable "t0_name" {}
variable "tz" {}
variable "edgecluster" {}
variable "count" {}
#variable count "{count=3}

provider "nsxt" {
  host = "${var.nsx_manager}"
  username = "${var.nsx_username}"
  password = "${var.nsx_password}"
  allow_unverified_ssl = true
}

data "nsxt_edge_cluster" "edge_cluster1" {
  display_name = "${var.edgecluster}"
}

resource "nsxt_dhcp_server_profile" "dhcp_profile" {
  description                 = "dhcp_profile provisioned by Terraform"
  display_name                = "dhcp_profile"
  edge_cluster_id             = "${data.nsxt_edge_cluster.edge_cluster1.id}"
  edge_cluster_member_indexes = [0, 1]

  tag = {
    scope = "color"
    tag   = "red"
  }
}

resource "nsxt_logical_dhcp_server" "logical_dhcp_server" {
  display_name     = "logical_dhcp_server"
  description      = "logical_dhcp_server provisioned by Terraform"
  dhcp_profile_id  = "${nsxt_dhcp_server_profile.dhcp_profile.id}"
  dhcp_server_ip   = "192.17.1.2/24"
  gateway_ip       = "192.17.1.1"
  domain_name      = "rkc.local"
  dns_name_servers = ["192.168.0.96"]
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-0" {
  display_name           = "ip pool"
  description            = "ip pool"
  logical_dhcp_server_id = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
  gateway_ip             = "192.17.1.1"
  lease_time             = 1296000
  error_threshold        = 98
  warning_threshold      = 70

  ip_range {
    start = "192.17.1.100"
    end   = "192.17.1.254"
  }
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-1" {
  display_name           = "ip pool"
  description            = "ip pool"
  logical_dhcp_server_id = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
  gateway_ip             = "192.17.2.1"
  lease_time             = 1296000
  error_threshold        = 98
  warning_threshold      = 70

  ip_range {
    start = "192.17.2.100"
    end   = "192.17.2.254"
  }
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-2" {
  display_name           = "ip pool"
  description            = "ip pool"
  logical_dhcp_server_id = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
  gateway_ip             = "192.17.3.1"
  lease_time             = 1296000
  error_threshold        = 98
  warning_threshold      = 70

  ip_range {
    start = "192.17.3.100"
    end   = "192.17.3.254"
  }
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-3" {
  display_name           = "ip pool"
  description            = "ip pool"
  logical_dhcp_server_id = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
  gateway_ip             = "192.17.4.1"
  lease_time             = 1296000
  error_threshold        = 98
  warning_threshold      = 70

  ip_range {
    start = "192.17.4.100"
    end   = "192.17.4.254"
  }
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-4" {
  display_name           = "ip pool"
  description            = "ip pool"
  logical_dhcp_server_id = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
  gateway_ip             = "192.17.5.1"
  lease_time             = 1296000
  error_threshold        = 98
  warning_threshold      = 70

  ip_range {
    start = "192.17.5.100"
    end   = "192.17.5.254"
  }
}

resource "nsxt_dhcp_relay_profile" "dr_profile" {
  description  = "DRP provisioned by Terraform"
  display_name = "DRP"

  tag {
    scope = "color"
    tag   = "red"
  }

  server_addresses = ["192.17.1.2"]
}


resource "nsxt_dhcp_relay_service" "dr_service" {
  display_name          = "DRS"
  dhcp_relay_profile_id = "${nsxt_dhcp_relay_profile.dr_profile.id}"
}


