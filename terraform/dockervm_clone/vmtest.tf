provider "vsphere" {
  user = "administrator@rkc.local"
  password = "Nicira123$"
  vsphere_server = "iotvc.rkc.local"
  allow_unverified_ssl = true 
}

data "vsphere_datacenter" "dc" {
  name = "iot_dc"
}

data "vsphere_datastore" "datastore" {
  name = "nsx_lab"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster1" {
  name = "comp1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster2" {
  name = "comp2"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster3" {
  name = "comp3"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name = "ls-192.168.100.0"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "vmnetwork" {
  name = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "k8snetwork" {
  name = "k8svif"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

/* refer this vm template to clone vm */
data "vsphere_virtual_machine" "template" {
  name = "vm_template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm1" {
  count = 5
  name = "k8s-vm1${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster2.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory = 8192
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = "${data.vsphere_network.vmnetwork.id}"
    use_static_mac = true
    mac_address = "00:50:56:01:03:0${count.index}"
  }

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  network_interface {
    network_id = "${data.vsphere_network.k8snetwork.id}"
  }

  disk {
    label = "disk0"
    size = 128
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone = "true"
  }

}

resource "vsphere_virtual_machine" "vmi2" {
  count = 0
  name = "iot-vm2${count.index}"
  resource_pool_id= "${data.vsphere_compute_cluster.cluster2.resource_pool_id}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory = 512
  guest_id = "ubuntu64Guest"
  wait_for_guest_net_timeout = 0

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size = 128
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"                                                       
    linked_clone = "true"                                                                                               
  }                                                                                                                     
                                                                                                                        
}

resource "vsphere_virtual_machine" "vmi3" {                                                                                     
  count = 0                                                                                                                    
  name = "iot-vm3${count.index}"                                                                                                
  resource_pool_id= "${data.vsphere_compute_cluster.cluster3.resource_pool_id}"                                                 
  datastore_id = "${data.vsphere_datastore.datastore.id}"                                                                       
                                                                                                                                
  num_cpus = 1                                                                                                                  
  memory = 512                                                                                                                  
  guest_id = "ubuntu64Guest"                                                                                                    
  wait_for_guest_net_timeout = 0                                                                                                
                                                                                                                                
  network_interface {                                                                                                           
    network_id = "${data.vsphere_network.network.id}"                                                                           
  }                                                                                                                             
                                                                                                                                
  disk {                                                                                                                        
    label = "disk0"                                                                                                             
    size = 128                                                                                                                  
  }                                                                                                                             
  clone {                                                                                                                       
    template_uuid = "${data.vsphere_virtual_machine.template.id}"                                                               
    linked_clone = "true"                                                                                                       
  }                                                                                                                             
                                                                                                                                
}                          
