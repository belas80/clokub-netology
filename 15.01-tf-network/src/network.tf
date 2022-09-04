# Network
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

# Route-table
resource "yandex_vpc_route_table" "lab-rt-a" {
  network_id = yandex_vpc_network.lab-net.id
  name       = "lab-rt-a"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat-instance.network_interface[0].ip_address
  }
}

# Public subnet
resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  name           = "public"
  network_id     = yandex_vpc_network.lab-net.id
}

# Private subnet
resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  name           = "private"
  network_id     = yandex_vpc_network.lab-net.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}
