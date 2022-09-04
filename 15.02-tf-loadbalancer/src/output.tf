#output "external_ip_address_public_instace" {
#  value = yandex_compute_instance.public-instance.network_interface[0].nat_ip_address
#}

output "address_lb" {
  value = yandex_lb_network_load_balancer.foo.listener
}
