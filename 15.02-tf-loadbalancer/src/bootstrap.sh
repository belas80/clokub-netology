#!/bin/bash
cd /var/www/html
echo \"<html><h1>My cool web-server `hostname`</h1><img src=\"https://storage.yandexcloud.net/${yandex_storage_object.test-object.bucket}/${yandex_storage_object.test-object.key}\" alt=\"Моя картинка\"></html>\" > index.html