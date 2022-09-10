#// Create Backend Group
#resource "yandex_alb_backend_group" "test-backend-group" {
#  name                     = "test-backend-group"
#
#  http_backend {
#    name                   = "test-backend"
#    weight                 = 1
#    port                   = 80
#    target_group_ids       = ["${yandex_compute_instance_group.ig-2.application_load_balancer[0].target_group_id}"]
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
#
#// Create http router
#resource "yandex_alb_http_router" "tf-router" {
#  name   = "http-router1"
#}
#
#resource "yandex_alb_virtual_host" "my-virtual-host" {
#  name           = "my-virtual-host"
#  http_router_id = yandex_alb_http_router.tf-router.id
#  route {
#    name = "to-ig2"
#    http_route {
#      http_route_action {
#        backend_group_id = "${yandex_alb_backend_group.test-backend-group.id}"
#        timeout          = "3s"
#      }
#    }
#  }
#}
#
#// Create application load balancer
#resource "yandex_alb_load_balancer" "test-balancer" {
#  name        = "my-alb-balancer"
#  network_id  = "${yandex_vpc_network.lab-net.id}"
#
#  allocation_policy {
#    location {
#      zone_id   = "ru-central1-a"
#      subnet_id = "${yandex_vpc_subnet.public.id}"
#    }
#  }
#
#  listener {
#    name = "my-listener-alb"
#    endpoint {
#      address {
#        external_ipv4_address {
#        }
#      }
#      ports = [ 80 ]
#    }
#    http {
#      handler {
#        http_router_id = "${yandex_alb_http_router.tf-router.id}"
#      }
#    }
#  }
#}
