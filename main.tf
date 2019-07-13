terraform {
  required_version = ">= 0.12"
}

resource "random_id" "this" {
  count       = var.create && var.use_name_prefix && var.name_prefix == "" ? 1 : 0
  byte_length = 8
}

locals {
  this_net_id = concat(
    openstack_networking_network_v2.this.*.id,
    [""],
  )[0]
  this_net_name = var.use_name_prefix ? (var.name_prefix == "" ? "${random_id.this[0].hex}-${var.name}" : "${var.name_prefix}-${var.name}") : var.name
}

resource "openstack_networking_network_v2" "this" {
  count          = var.create && false == var.use_name_prefix ? 1 : 0
  name           = local.this_net_name
  description    = var.description
  admin_state_up = var.admin_state_up
}

resource "openstack_networking_subnet_v2" "this" {
  count      = var.create ? length(var.subnets) : 0
  network_id = local.this_net_id
  name = format(
    "%s-subnet-ipv%s-%s",
    local.this_net_name,
    lookup(var.subnets[count.index], "ip_version", null),
    count.index + 1
  )
  description = lookup(var.subnets[count.index], "description", null)
  cidr        = lookup(var.subnets[count.index], "cidr", null)
  ip_version  = lookup(var.subnets[count.index], "ip_version", null)
  dns_nameservers = lookup(var.subnets[count.index], "dns_nameservers", "") == "" ? null : split(",", lookup(var.subnets[count.index], "dns_nameservers", ""))
  enable_dhcp = lookup(var.subnets[count.index], "enable_dhcp", null)
  gateway_ip  = lookup(var.subnets[count.index], "gateway_ip", null)
  no_gateway  = lookup(var.subnets[count.index], "no_gateway", null)
}

data "openstack_networking_network_v2" "this" {
  count = var.create && contains(keys(var.router), "external_network_name") ? 1 : 0
  name = lookup(var.router, "external_network_name", null)
}

resource "openstack_networking_router_v2" "this" {
  count = var.create && lookup(var.router, "create", false) == true ? 1 : 0
  name                = lookup(var.router, "name", null)
  admin_state_up      = lookup(var.router, "admin_state_up", var.admin_state_up)
  description         = tobool(lookup(var.router, "description", false))
  external_network_id = lookup(var.router, "external_network_id", data.openstack_networking_network_v2.this[0].id)
}

locals {
  router_subnets_indexes = [for x in var.subnets : index(var.subnets, x) if lookup(x, "router_id", "") != "" ]
}

resource "openstack_networking_router_interface_v2" "this" {
  count = var.create ? length(local.router_subnets_indexes) : 0
  router_id = (lookup(var.subnets[local.router_subnets_indexes[count.index]], "router_id", "") == "@self"
    ? openstack_networking_router_v2.this[0].id
    : lookup(var.router, "router_id", "")
  )
  subnet_id = openstack_networking_subnet_v2.this[local.router_subnets_indexes[count.index]].id
}