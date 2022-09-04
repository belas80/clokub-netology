#!/bin/bash
cd /var/www/html
cat <<EOF > index.html
<html>
  <h1>My cool web-server $(hostname -f)</h1>
  <img src="https://storage.yandexcloud.net/${yandex_storage_object.test-object.bucket}/${yandex_storage_object.test-object.key}">
</html>
EOF
