# Домашнее задание к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```
```shell
# Вывод консоли
% kubectl create serviceaccount netology
serviceaccount/netology created
```

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```
```shell
# Вывод консоли
 % kubectl get serviceaccounts
NAME       SECRETS   AGE
default    1         47d
netology   1         45s
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```
```shell
# Вывод консоли
% kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-08-11T17:15:13Z"
  name: netology
  namespace: stage
  resourceVersion: "276336"
  uid: 0075c48a-797b-4e68-b6f4-67c240dd3fa1
secrets:
- name: netology-token-mf2vv

% kubectl get serviceaccount default -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2022-06-24T18:30:42Z",
        "name": "default",
        "namespace": "stage",
        "resourceVersion": "4185",
        "uid": "3ad0df78-7d6a-415d-ad8e-686c8f6b7857"
    },
    "secrets": [
        {
            "name": "default-token-slvpk"
        }
    ]
}
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```
```shell
# Вывод консоли JSON
% kubectl get serviceaccounts -o json > serviceaccounts.json
% cat serviceaccounts.json 
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "kind": "ServiceAccount",
            "metadata": {
                "creationTimestamp": "2022-06-24T18:30:42Z",
                "name": "default",
                "namespace": "stage",
                "resourceVersion": "4185",
                "uid": "3ad0df78-7d6a-415d-ad8e-686c8f6b7857"
            },
            "secrets": [
                {
                    "name": "default-token-slvpk"
                }
            ]
        },
        {
            "apiVersion": "v1",
            "kind": "ServiceAccount",
            "metadata": {
                "creationTimestamp": "2022-08-11T17:15:13Z",
                "name": "netology",
                "namespace": "stage",
                "resourceVersion": "276336",
                "uid": "0075c48a-797b-4e68-b6f4-67c240dd3fa1"
            },
            "secrets": [
                {
                    "name": "netology-token-mf2vv"
                }
            ]
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
```
```shell
# Вывод консоли YAML
% cat netology.yml 
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-08-11T17:15:13Z"
  name: netology
  namespace: stage
  resourceVersion: "276336"
  uid: 0075c48a-797b-4e68-b6f4-67c240dd3fa1
secrets:
- name: netology-token-mf2vv
```

### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```
```shell
# Вывод консоли
% kubectl delete serviceaccount netology
serviceaccount "netology" deleted
% kubectl get serviceaccounts 
NAME      SECRETS   AGE
default   1         47d
```

### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```
```shell
# Вывод консоли
% kubectl apply -f netology.yml
serviceaccount/netology created
% kubectl get serviceaccounts netology 
NAME       SECRETS   AGE
netology   2         23s
```

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить
доступность API Kubernetes