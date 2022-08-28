output "externa_ip_address_nat_instance" {
  value = yandex_compute_instance.nat-instance.network_interface[0].nat_ip_address
}

output "external_ip_address_public_instace" {
  value = yandex_compute_instance.public-instance.network_interface[0].nat_ip_address
}

output "internal_ip_address_private_instace" {
  value = yandex_compute_instance.private-instance.network_interface[0].ip_address
}

output "public_subnet" {
  value = yandex_vpc_subnet.public.v4_cidr_blocks
}

output "private_subnet" {
  value = yandex_vpc_subnet.private.v4_cidr_blocks
}

output "route_table" {
  value = yandex_vpc_route_table.lab-rt-a.static_route
}