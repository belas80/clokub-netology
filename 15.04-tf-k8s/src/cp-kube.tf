resource "yandex_kubernetes_cluster" "cp-kube-bel2022" {
  name = "cp-kube-bel2022"
  #  description = "description"

  network_id = yandex_vpc_network.lab-net.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.public-a.zone
        subnet_id = yandex_vpc_subnet.public-a.id
      }

      location {
        zone      = yandex_vpc_subnet.public-b.zone
        subnet_id = yandex_vpc_subnet.public-b.id
      }

      location {
        zone      = yandex_vpc_subnet.public-c.zone
        subnet_id = yandex_vpc_subnet.public-c.id
      }
    }

    version   = "1.22"
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

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

  service_account_id      = yandex_iam_service_account.kube-sa.id
  node_service_account_id = yandex_iam_service_account.kube-sa.id
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }

  network_policy_provider = "CALICO"
  release_channel         = "STABLE"
}