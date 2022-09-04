output "instances_group" {
  value = yandex_compute_instance_group.ig-1.instances
}

#output "instances_group" {
#  value = yandex_compute_instance_group.ig-1.instance_template.network_interface[0].ipv4
#}

output "external_ip_address_public_instace" {
  value = yandex_compute_instance.public-instance.network_interface[0].nat_ip_address
}

#output "exernal_ip_address_lb" {
#  value = yandex_lb_network_load_balancer.foo
#}
