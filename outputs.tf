output "network_id" {
  value = concat(
    openstack_networking_network_v2.this.*.id,
    [""],
  )[0]
}

output "subnets" {
  value = openstack_networking_subnet_v2.this.*
}