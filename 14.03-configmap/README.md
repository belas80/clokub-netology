# Домашнее задание к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```shell
% kubectl create configmap nginx-config --from-file=src/nginx.conf
configmap/nginx-config created

% kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```

### Как просмотреть список карт конфигураций?

```shell
% kubectl get configmaps
NAME               DATA   AGE
domain             1      3m22s
kube-root-ca.crt   1      47d
nginx-config       1      3m43s

% kubectl get configmap
NAME               DATA   AGE
domain             1      3m48s
kube-root-ca.crt   1      47d
nginx-config       1      4m9s
```

### Как просмотреть карту конфигурации?

```shell
% kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      4m42s

% kubectl describe configmap domain
Name:         domain
Namespace:    stage
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
```

### Как получить информацию в формате YAML и/или JSON?

```shell
% kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |-
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2022-08-10T19:21:45Z"
  name: nginx-config
  namespace: stage
  resourceVersion: "257775"
  uid: 8d019c87-4dab-4539-a005-0c23c95610a9

% kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-08-10T19:22:06Z",
        "name": "domain",
        "namespace": "stage",
        "resourceVersion": "257821",
        "uid": "869ae137-e8ea-4962-875f-dab29b99afce"
    }
}
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```shell
% kubectl get configmaps nginx-config domain -o json > src/configmaps.json 
% cat src/configmaps.json                                                 
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "nginx.conf": "server {\n    listen 80;\n    server_name  netology.ru www.netology.ru;\n    access_log  /var/log/nginx/domains/netology.ru-access.log  main;\n    error_log   /var/log/nginx/domains/netology.ru-error.log info;\n    location / {\n        include proxy_params;\n        proxy_pass http://10.10.10.10:8080/;\n    }\n}"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2022-08-10T19:21:45Z",
                "name": "nginx-config",
                "namespace": "stage",
                "resourceVersion": "257775",
                "uid": "8d019c87-4dab-4539-a005-0c23c95610a9"
            }
        },
        {
            "apiVersion": "v1",
            "data": {
                "name": "netology.ru"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2022-08-10T19:22:06Z",
                "name": "domain",
                "namespace": "stage",
                "resourceVersion": "257821",
                "uid": "869ae137-e8ea-4962-875f-dab29b99afce"
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
```
```shell
% kubectl get configmap nginx-config -o yaml > src/nginx-config.yml
% cat src/nginx-config.yml                                         
apiVersion: v1
data:
  nginx.conf: |-
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2022-08-10T19:21:45Z"
  name: nginx-config
  namespace: stage
  resourceVersion: "257775"
  uid: 8d019c87-4dab-4539-a005-0c23c95610a9
```

### Как удалить карту конфигурации?

```shell
% kubectl delete configmap nginx-config
configmap "nginx-config" deleted

% kubectl get configmaps 
NAME               DATA   AGE
domain             1      17m
kube-root-ca.crt   1      47d

% kubectl get configmaps nginx-config
Error from server (NotFound): configmaps "nginx-config" not found
```

### Как загрузить карту конфигурации из файла?

```shell
% kubectl apply -f src/nginx-config.yml 
configmap/nginx-config created

% kubectl get configmaps 
NAME               DATA   AGE
domain             1      18m
kube-root-ca.crt   1      47d
nginx-config       1      5s

% kubectl get configmaps nginx-config 
NAME           DATA   AGE
nginx-config   1      11s
```

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома  
  
Создадим манифест [my-pod.yml](src/my-pod.yml) для пода, где примапим `nginx-config` как том, а `domain` как переменные окружения:  
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: myapp
    image: fedora:latest
    command: ['/bin/bash', '-c']
    args: ["env; ls -la /etc/nginx/conf.d; sleep 600"]
    env:
      - name: SPECIAL_LEVEL_KEY
        valueFrom:
          configMapKeyRef:
            name: domain
            key: name
    envFrom:
      - configMapRef:
          name: domain
    volumeMounts:
      - name: config
        mountPath: /etc/nginx/conf.d
        readOnly: true
  volumes:
  - name: config
    configMap:
      name: nginx-config
  restartPolicy: Never
```
Создаем под и проверяем:  
```shell
% kubectl apply -f src/my-pod.yml
pod/netology-14.3 created

# В логах будет вывод переменных среды и листинг ls директории /etc/nginx/conf.d, сгрепаем нужные значения для удобства
% kubectl logs po/netology-14.3 | egrep "SPECIAL_LEVEL_KEY|name| root"
SPECIAL_LEVEL_KEY=netology.ru
name=netology.ru
drwxrwxrwx 3 root root 4096 Aug 10 21:03 .
drwxr-xr-x 3 root root 4096 Aug 10 21:03 ..
drwxr-xr-x 2 root root 4096 Aug 10 21:03 ..2022_08_10_21_03_04.3036099703
lrwxrwxrwx 1 root root   32 Aug 10 21:03 ..data -> ..2022_08_10_21_03_04.3036099703
lrwxrwxrwx 1 root root   17 Aug 10 21:03 nginx.conf -> ..data/nginx.conf

# Переменные среды можно и так проверить
% kubectl exec po/netology-14.3 -i -t -- sh -c 'env | egrep "SPECIAL_LEVEL_KEY|name"'
SPECIAL_LEVEL_KEY=netology.ru
name=netology.ru

# Прочитаем nginx.conf
% kubectl exec po/netology-14.3 -- cat /etc/nginx/conf.d/nginx.conf   
server {
    listen 80;
    server_name  netology.ru www.netology.ru;
    access_log  /var/log/nginx/domains/netology.ru-access.log  main;
    error_log   /var/log/nginx/domains/netology.ru-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://10.10.10.10:8080/;
    }
}%                                  
```
