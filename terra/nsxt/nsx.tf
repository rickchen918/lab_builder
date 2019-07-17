variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}
variable "t0_name" {}
variable "tz" {}
variable "edgecluster" {}

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

resource "nsxt_logical_switch" "switch1" {
  admin_state = "UP"
  display_name = "terraform_ls"
  transport_zone_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  replication_mode = "MTEP"
}

resource "nsxt_logical_tier1_router" "t1" {
  display_name = "terraform_t1"
  failover_mode = "PREEMPTIVE"
  edge_cluster_id = "${data.nsxt_edge_cluster.edgecluster.id}"
  enable_router_advertisement = true 
  advertise_connected_routes = true 
}

resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0" {
  display_name = "downlink_to_t1"
  logical_router_id = "${data.nsxt_logical_tier0_router.t0.id}"
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1" {
  display_name = "downlink_to_t1"
  logical_router_id = "${nsxt_logical_tier1_router.t1.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.link_port_tier0.id}"
}

resource "nsxt_logical_port" "logical_port1" {
  admin_state = "UP"
  display_name = "LP1 provision from terraform"
  logical_switch_id = "${nsxt_logical_switch.switch1.id}"
}

resource "nsxt_logical_router_downlink_port" "downlink_port" {
  display_name = "link to logical switch"
  logical_router_id = "${nsxt_logical_tier1_router.t1.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.logical_port1.id}"
  ip_address = "192.168.83.1/24"
}
