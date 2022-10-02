resource "yandex_kubernetes_node_group" "ng-kube-bel2022" {
  cluster_id  = yandex_kubernetes_cluster.cp-kube-bel2022.id
  name        = "ng-kube-bel2022"
  description = "description"
  version     = "1.22"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.public-a.id}"]
    }

    resources {
      memory        = 2
      cores         = 2
      core_fraction = 50
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}