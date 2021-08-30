terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  cloud = terraform.workspace
}

module "example_subnet_routes" {
  source = "haxorof/network/openstack"
  name   = "example-subnet-routes"
  router = {
    create = true
    name   = "example-subnet-routes"
  }
  subnets = [
    {
      cidr      = "192.168.199.0/24"
      router_id = "@self"
      routes = [
        { destination_cidr = "10.0.1.0/24", next_hop = "192.168.199.254" },
        { destination_cidr = "10.0.2.0/24", next_hop = "192.168.199.253" },
      ]
    },
    {
      cidr      = "192.168.198.0/24"
      router_id = null
      routes    = []
    },
  ]
}
