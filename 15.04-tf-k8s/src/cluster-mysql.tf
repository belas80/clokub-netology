//noinspection MissingProperty
resource "yandex_mdb_mysql_cluster" "mysql-bel2022" {
  name                = "mysql-bel2022"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.lab-net.id
  version             = "8.0"
  deletion_protection = true

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  //noinspection HCLUnknownBlockType
  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 21
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  host {
    zone      = "ru-central1-a"
    name      = "ndb-a-1"
    subnet_id = yandex_vpc_subnet.private-a.id
  }

  host {
    zone      = "ru-central1-a"
    name      = "ndb-a-2"
    subnet_id = yandex_vpc_subnet.private-a.id
  }

  host {
    zone                    = "ru-central1-b"
    name                    = "ndb-b-1"
    replication_source_name = "ndb-a-1"
    subnet_id               = yandex_vpc_subnet.private-b.id
  }

  host {
    zone                    = "ru-central1-c"
    name                    = "ndb-c-1"
    replication_source_name = "ndb-b-1"
    subnet_id               = yandex_vpc_subnet.private-c.id
  }

}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-bel2022.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "user1" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-bel2022.id
  name       = "user1"
  password   = "VjqCegthGfhjkm1"
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}