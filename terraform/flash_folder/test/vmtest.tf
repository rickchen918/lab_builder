provider "vsphere" {
  user = "administrator@rkc.local"
  password = "Nicira123$"
  vsphere_server = "iotvc.rkc.local"
  allow_unverified_ssl = true 
}

data "vsphere_datacenter" "dc" {
  name = "flash_dc"
}

data "vsphere_datastore" "datastore" {
  name = "ssd_lab"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster1" {
  name = "flash_compute"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name = "si-lab-t1-100"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

/* refer this vm template to clone vm */
data "vsphere_virtual_machine" "template" {
  name = "vm_template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm1" {
  count = 4
  name = "flash-vm1${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster1.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory = 16384
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0
  nested_hv_enabled = true

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size = 120
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone = "true"
  }

}



