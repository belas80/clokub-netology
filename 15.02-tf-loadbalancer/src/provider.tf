terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.77.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1gmh5fl71a23gh6qrqc"
  folder_id                = "b1g9eq93ionckal26dpc"
  zone                     = "ru-central1-a"
}