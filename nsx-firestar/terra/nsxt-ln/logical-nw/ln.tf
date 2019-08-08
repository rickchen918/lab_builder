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

data "nsxt_transport_zone" "overlay_tz" {
  display_name = "${var.tz}"
}

data "nsxt_logical_tier0_router" "t0" {
  display_name = "${var.t0_name}"
}

data "nsxt_edge_cluster" "edgecluster" {
  display_name = "${var.edgecluster}"
}

/* create dhcp related service */ 

resource "nsxt_dhcp_server_profile" "dhcp_profile" {
  description                 = "dhcp_profile provisioned by Terraform"
  display_name                = "dhcp_profile"
  edge_cluster_id             = "${data.nsxt_edge_cluster.edgecluster.id}"
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
  dhcp_server_ip   = "192.17.0.2/24"
  gateway_ip       = "192.17.0.1"
  domain_name      = "rkc.local"
  dns_name_servers = ["192.168.0.96"]
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-0" {
  display_name           = "ip pool"
  description            = "ip pool"
  logical_dhcp_server_id = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
  gateway_ip             = "192.17.0.1"
  lease_time             = 1296000
  error_threshold        = 98
  warning_threshold      = 70

  ip_range {
    start = "192.17.0.100"
    end   = "192.17.0.254"
  }
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-1" {
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

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-2" {
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

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-3" {
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

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool-4" {
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

resource "nsxt_dhcp_relay_profile" "dr_profile" {
  description  = "DRP provisioned by Terraform"
  display_name = "DRP"

  tag {
    scope = "color"
    tag   = "red"
  }

  server_addresses = ["192.17.0.2"]
}


resource "nsxt_dhcp_relay_service" "dr_service" {
  display_name          = "DRS"
  dhcp_relay_profile_id = "${nsxt_dhcp_relay_profile.dr_profile.id}"
}

/* crete logical network topology */
resource "nsxt_logical_switch" "switch1" {
  count = "${var.count}"
  admin_state = "UP"
  display_name = "terraform_ls_${count.index}"
  transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  replication_mode = "MTEP"
}

resource "nsxt_logical_tier1_router" "t1" {
  count = "${var.count}"
  display_name = "terraform_t1_${count.index}"
  failover_mode = "PREEMPTIVE"
  edge_cluster_id = "${data.nsxt_edge_cluster.edgecluster.id}"
  enable_router_advertisement = true 
  advertise_connected_routes = true 
}

resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0" {
  count = "${var.count}"
  display_name = "downlink_to_t1_${count.index}"
  logical_router_id = "${data.nsxt_logical_tier0_router.t0.id}"
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1" {
  count = "${var.count}"
  display_name = "downlink_to_t1_$(count.index)"
  logical_router_id = "${element(nsxt_logical_tier1_router.t1.*.id,count.index)}"
  linked_logical_router_port_id = "${element(nsxt_logical_router_link_port_on_tier0.link_port_tier0.*.id,count.index)}"
}


resource "nsxt_logical_port" "logical_port1" {
  count = "${var.count}"
  admin_state = "UP"
  display_name = "LP${count.index} provision from terraform"
  logical_switch_id = "${element(nsxt_logical_switch.switch1.*.id,count.index)}"
}

resource "nsxt_logical_router_downlink_port" "downlink_port" {
  count = "${var.count}"
  display_name = "link to logical switch ${count.index}"
  logical_router_id = "${element(nsxt_logical_tier1_router.t1.*.id,count.index)}"
  linked_logical_switch_port_id = "${element(nsxt_logical_port.logical_port1.*.id,count.index)}"
  ip_address = "192.17.${count.index}.1/24" 
/*  subnet {
    ip_addresses  = ["192.17.${count.index}.1"]
    prefix_length = 24
  } */
   service_binding {
    target_id   = "${nsxt_dhcp_relay_service.dr_service.id}"
    target_type = "LogicalService"
  } 
}


