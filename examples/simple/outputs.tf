output "network_id" {
  value = module.simple_one_net.network_id
}

output "number_of_subnets" {
  value = length(module.simple_one_net.subnets.*.id)
}

output "subnet_1_id" {
  value = module.simple_one_net.subnets[0].id
}