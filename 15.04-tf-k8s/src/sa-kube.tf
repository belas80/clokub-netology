resource "yandex_iam_service_account" "kube-sa" {
  name        = "kube-sa"
  description = "service account to manage k8s"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yandex_folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.kube-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.kube-sa,
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  folder_id = var.yandex_folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.kube-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.kube-sa,
  ]
}