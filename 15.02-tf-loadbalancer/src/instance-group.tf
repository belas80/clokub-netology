resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yandex_folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ig-sa,
  ]
}

resource "yandex_compute_instance_group" "ig-1" {
  name               = "fixed-ig"
  folder_id          = var.yandex_folder_id
  service_account_id = yandex_iam_service_account.ig-sa.id
  depends_on         = [yandex_resourcemanager_folder_iam_binding.editor, yandex_storage_object.test-object]
  instance_template {
    platform_id = "standard-v3"
    name        = "my-instance-{instance.index}"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
        type     = "network-ssd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.lab-net.id
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat        = true
    }

    metadata = {
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      user-data = <<-EOT
        #!/bin/bash
        cd /var/www/html
        cat <<EOF > index.html
        <html>
          <h1>My cool web-server $(hostname -f)</h1>
          <img src="https://storage.yandexcloud.net/${yandex_storage_object.test-object.bucket}/${yandex_storage_object.test-object.key}">
        </html>
        EOF
       EOT
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval            = 5
    timeout             = 2
    healthy_threshold   = 3
    unhealthy_threshold = 3
    http_options {
      path = "/"
      port = 80
    }
  }

  load_balancer {
    target_group_name = "my-target-group-lb"
  }
}
