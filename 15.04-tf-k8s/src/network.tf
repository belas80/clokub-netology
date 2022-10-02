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

# Public subnet a
resource "yandex_vpc_subnet" "public-a" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  name           = "public-a"
  network_id     = yandex_vpc_network.lab-net.id
}

# Public subnet b
resource "yandex_vpc_subnet" "public-b" {
  v4_cidr_blocks = ["192.168.11.0/24"]
  zone           = "ru-central1-b"
  name           = "public-b"
  network_id     = yandex_vpc_network.lab-net.id
}

# Public subnet c
resource "yandex_vpc_subnet" "public-c" {
  v4_cidr_blocks = ["192.168.12.0/24"]
  zone           = "ru-central1-c"
  name           = "public-c"
  network_id     = yandex_vpc_network.lab-net.id
}

# Private subnet a
resource "yandex_vpc_subnet" "private-a" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  name           = "private-a"
  network_id     = yandex_vpc_network.lab-net.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

# Private subnet b
resource "yandex_vpc_subnet" "private-b" {
  v4_cidr_blocks = ["192.168.21.0/24"]
  zone           = "ru-central1-b"
  name           = "private-b"
  network_id     = yandex_vpc_network.lab-net.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

# Private subnet c
resource "yandex_vpc_subnet" "private-c" {
  v4_cidr_blocks = ["192.168.22.0/24"]
  zone           = "ru-central1-c"
  name           = "private-c"
  network_id     = yandex_vpc_network.lab-net.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}
