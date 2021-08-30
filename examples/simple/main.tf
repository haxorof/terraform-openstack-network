terraform {
  required_version = ">= 0.13"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}


provider "openstack" {
  cloud = terraform.workspace
}

module "example_simple_one_net" {
  source      = "haxorof/network/openstack"
  name        = "example-simple-one-net"
  description = "Network with only one subnet connected to it."
  subnets = [
    { cidr = "192.168.199.0/24" },
  ]
}

module "example_simple_two_dns_net" {
  source      = "haxorof/network/openstack"
  name        = "example-two-dns-net"
  description = "Network with only two subnet connected to it with defined DNS."
  subnets = [
    { cidr = "192.168.0.0/24", dns_nameservers = ["8.8.8.8", "8.8.4.4"] },
    { cidr = "192.168.1.0/24", dns_nameservers = ["1.1.1.1", "1.0.0.1"] },
  ]
}

resource "openstack_networking_port_v2" "port_subnet_0" {
  name           = "example-port-subnet-0"
  network_id     = module.example_simple_two_dns_net.network_id
  admin_state_up = "true"
  fixed_ip {
    subnet_id = module.example_simple_two_dns_net.subnets[0].id
  }
}

resource "openstack_networking_port_v2" "port_subnet_1" {
  name           = "example-port-subnet-1"
  network_id     = module.example_simple_two_dns_net.network_id
  admin_state_up = "true"
  fixed_ip {
    subnet_id  = module.example_simple_two_dns_net.subnets[1].id
    ip_address = cidrhost(module.example_simple_two_dns_net.subnets[1].cidr, 5)
  }
}
