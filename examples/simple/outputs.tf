output "network_id" {
  value = module.example_simple_one_net.network_id
}

output "number_of_subnets" {
  value = length(module.example_simple_one_net.subnets.*.id)
}

output "subnet_1_id" {
  value = concat(module.example_simple_one_net.subnets.*.id, [""])[0]
}
