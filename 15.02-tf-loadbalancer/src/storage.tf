// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.yandex_folder_id
  name      = "tf-test-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yandex_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "test" {
  depends_on = [yandex_resourcemanager_folder_iam_member.sa-editor, yandex_iam_service_account_static_access_key.sa-static-key]
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "belyaev-01092022"
}

resource "yandex_storage_object" "test-object" {
  depends_on = [yandex_storage_bucket.test]
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "belyaev-01092022"
  key        = "terraform.png"
  source     = "../img/terraform.png"
  acl        = "public-read"
}