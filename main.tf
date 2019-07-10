terraform {
  required_version = ">= 0.12"
}

resource "random_id" "this" {
  count       = var.create && var.use_name_prefix && var.name_prefix == "" ? 1 : 0
  byte_length = 8
}

##################################
# Get ID of created Security Group
##################################
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
