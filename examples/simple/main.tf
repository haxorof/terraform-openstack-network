provider "openstack" {
  cloud = terraform.workspace
}

module "simple_one_net" {
  source      = "haxorof/network/openstack"
  name        = "simple-one-net"
  description = "Network with only one subnet connected to it."
  subnets = [
    { cidr = "192.168.199.0/24", ip_version = 4 },
  ]
}

module "simple_two_dns_net" {
  source         = "haxorof/network/openstack"
  name           = "two-dns-net"
  description    = "Network with only two subnet connected to it with defined DNS."
  admin_state_up = "true"
  subnets = [
    { cidr = "192.168.0.0/24", ip_version = 4, dns_nameservers = "8.8.8.8,8.8.4.4" },
    { cidr = "192.168.1.0/24", ip_version = 4, dns_nameservers = "1.1.1.1,1.0.0.1" },
  ]
}

resource "openstack_networking_port_v2" "port_subnet_0" {
  name           = "port-subnet-0"
  network_id     = module.simple_two_dns_net.network_id
  admin_state_up = "true"
  fixed_ip {
    subnet_id = module.simple_two_dns_net.subnets[0].id
  }
}

resource "openstack_networking_port_v2" "port_subnet_1" {
  name           = "port-subnet-1"
  network_id     = module.simple_two_dns_net.network_id
  admin_state_up = "true"
  fixed_ip {
    subnet_id  = module.simple_two_dns_net.subnets[1].id
    ip_address = cidrhost(module.simple_two_dns_net.subnets[1].cidr, 5)
  }
}
