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
}
