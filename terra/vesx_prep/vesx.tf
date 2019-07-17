provider "vsphere" {
  user = "administrator@rkc.local"
  password = "Nicira123$"
  vsphere_server = "vc.rkc.local"
  allow_unverified_ssl = true 
}

data "vsphere_datacenter" "dc" {
  name = "Home"
}

data "vsphere_datastore" "datastore" {
  name = "nsx_lab"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name = "cluster67"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name = "home_mgmt"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network65" {
  name = "65-0"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

/* refer this vm template to clone vm */
data "vsphere_virtual_machine" "template" {
  name = "esx67_ready_template" 
/*  name = "esx65_ready_template" */
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

/* create nested esx under cluster67 by linked clone */
resource "vsphere_virtual_machine" "vm" {
  count = 2
  name = "V2T-ESX${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 8
  memory = 16384
  guest_id = "vmkernel65Guest"
  wait_for_guest_net_timeout = 0
  nested_hv_enabled = true

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    use_static_mac = true
    mac_address = "00:50:56:01:02:0${count.index}"
  }

  network_interface {
    network_id = "${data.vsphere_network.network65.id}"
  }

  disk {
    label = "disk0"
    size = 40
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone = "true"
  }

}
