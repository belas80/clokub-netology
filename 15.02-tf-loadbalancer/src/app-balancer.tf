# Create Backend Group
#resource "yandex_alb_backend_group" "test-backend-group" {
#  name                     = "test-backend-group"
#
#  http_backend {
#    name                   = "test-backend"
#    weight                 = 1
#    port                   = 80
#    target_group_ids       = ["${yandex_compute_instance_group.ig-1.application_load_balancer[0].target_group_name}"]
#    load_balancing_config {
#      panic_threshold      = 90
#    }
#    healthcheck {
#      timeout              = "10s"
#      interval             = "2s"
#      healthy_threshold    = 10
#      unhealthy_threshold  = 15
#      http_healthcheck {
#        path               = "/"
#      }
#    }
#  }
#}

