# Terraform OpenStack Network Module

[![Terraform module](https://img.shields.io/badge/dynamic/json.svg?url=https://registry.terraform.io/v1/modules/haxorof/network/openstack&label=haxorof/network/openstack&query=$.version&color=blue)](https://registry.terraform.io/modules/haxorof/network/openstack)
![Module downloads](https://img.shields.io/badge/dynamic/json.svg?url=https://registry.terraform.io/v1/modules/haxorof/network/openstack&label=downloads&query=$.downloads&color=green)

Terraform module which creates networks including subnets and optionally router on OpenStack.

## Features

This modules aims to make it more compact to setup network, subnets and routers:

* Create a network and list of defined subnets
* Support for subnet routes
* Support creation of router if needed
* Subnets can be connected with router in module using `@self` notation

## Terraform versions

Terraform 0.13.

## Usage

There are several ways to use this module but here are two examples below:

### Network with one subnet and router

```hcl
module "example_net" {
  source = "haxorof/network/openstack"
  name   = "example"
  router = {
    create = true
    external_network_name = "ext-net"
  }
  subnets = [
    { cidr = "192.168.1.0/24", router_id = "@self" },
  ]
}
```

## Examples

* [Simple examples](https://github.com/haxorof/terraform-openstack-network/blob/master/examples/simple)

## License

This is an open source project under the [MIT](https://github.com/haxorof/terraform-openstack-network/blob/master/LICENSE) license.
