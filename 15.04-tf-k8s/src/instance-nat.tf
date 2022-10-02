resource "yandex_compute_instance" "nat-instance" {
  name                      = "nat-instance"
  platform_id               = "standard-v1"
  zone                      = "ru-central1-a"
  hostname                  = "nat-srv"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8josjq21d56924jfan"
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public-a.id
    ip_address = "192.168.10.254"
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}