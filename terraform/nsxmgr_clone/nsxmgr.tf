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
  name = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


/* refer this vm template to clone vm */
data "vsphere_virtual_machine" "template" {
/*  name = "esx67_ready_template" */
  name = "template_nsxmgr23"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

/* create nested esx under cluster67 by linked clone */
resource "vsphere_virtual_machine" "vm" {
  count = 1
  name = "home_nsxmgr"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory = 8192
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size = 200
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone = "true"
  }

}
