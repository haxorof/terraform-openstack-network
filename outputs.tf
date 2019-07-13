output "network_id" {
  value = concat(
    openstack_networking_network_v2.this.*.id,
    [""],
  )[0]
}

output "router_id" {
  value = concat(
    openstack_networking_router_v2.this.*.id,
    [lookup(var.router, "id", "")]
  )[0]
}

output "subnets" {
  value = openstack_networking_subnet_v2.this.*
}

