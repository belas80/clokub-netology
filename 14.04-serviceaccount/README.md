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
% kubectl get serviceaccount netology -o yaml > netology.yml
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

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```
```shell
# Вывод консоли
% kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1# 
```

Просмотреть переменные среды

```
env | grep KUBE
```
```shell
# Вывод консоли
sh-5.1# env | grep KUBE
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.233.0.1
KUBERNETES_SERVICE_HOST=10.233.0.1
KUBERNETES_PORT=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
```

Получить значения переменных

```
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
```
```shell
# Вывод консоли
sh-5.1# echo $K8S 
https://10.233.0.1:443
sh-5.1# echo $CACERT 
/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
sh-5.1# 
```

Подключаемся к API  

```
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
```
```shell
# Вывод длинный, укоротил
sh-5.1# curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
{
  "kind": "APIResourceList",
  "groupVersion": "v1",
  "resources": [
    {
      "name": "bindings",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
...
...
...
      "kind": "Service",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    }
  ]
}sh-5.1#  
```

## Пойдем дальше  
Cозданим сервис аккаунт `hobbit` с ограниченным доступом в неймспейсе `stage`. И попробуем постучатся им за пределами кубера.  
```shell
# Текущие неймспейсы
 % kubectl get namespaces 
NAME              STATUS   AGE
app1              Active   30d
app2              Active   30d
default           Active   48d
kube-node-lease   Active   48d
kube-public       Active   48d
kube-system       Active   48d
prod              Active   46d
stage             Active   48d

# Создаем сервис аккаунт
 % kubectl create serviceaccount hobbit -n stage
serviceaccount/hobbit created
```
Создадим отдельный конфиг `cluster.local-hobbit-kube.conf` для него:  
```
apiVersion: v1
kind: Config
users:
- name: hobbit
  user:
    token: eyJhbG....
clusters:
- cluster:
    certificate-authority-data: LS0tLS....    
    server: https://84.201.141.69:6443
  name: cluster.local
contexts:
- context:
    cluster: cluster.local
    user: hobbit
    namespace: stage
  name: cluster.local-hobbit-context
current-context: cluster.local-hobbit-context
```
Проверим появился ли у нас доступ к нашему кластеру  
```shell
% kubectl --kubeconfig ~/.kube/cluster.local-hobbit-kube.conf get po         
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:stage:hobbit" cannot list resource "pods" in API group "" in the namespace "stage"
```
Мы получим ошибку, потому что у нас нет роли и связки этой роли с сервисаккаунтом.  
Создаем роль с помощью манифста [read-exec-pods-svc-ing-role.yaml](src/read-exec-pods-svc-ing-role.yaml):  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: stage
  name: read-exec-pods-svc-ing
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log", "services", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch", "describe"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
- apiGroups: ["extensions"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
```
```shell
# Вывод консоли
% kubectl apply -f read-exec-pods-svc-ing-role.yaml
role.rbac.authorization.k8s.io/read-exec-pods-svc-ing created
```
Привязываем нашу роль с сервисаккаунтом, делаем рольбиндинг манифестом [](src/read-exec-pods-svc-ing-rolebinding.yaml):  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: hobbit-read-exec-pods-svc-ing-rolebinding
  namespace: stage
subjects:
- kind: User
  name: system:serviceaccount:stage:hobbit # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: read-exec-pods-svc-ing # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```
```shell
# Вывод консоли
% kubectl apply -f read-exec-pods-svc-ing-rolebinding.yaml 
rolebinding.rbac.authorization.k8s.io/hobbit-read-exec-pods-svc-ing-rolebinding created
```
Тестируем доступ в кластер.
```shell
# Читаем поды в неймспейсе stage
 % kubectl --kubeconfig ~/.kube/cluster.local-hobbit-kube.conf get po
NAME     READY   STATUS    RESTARTS   AGE
fedora   1/1     Running   0          111m

# Читаем поды в неймспейсе prod
% kubectl --kubeconfig ~/.kube/cluster.local-hobbit-kube.conf get po -n prod
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:stage:hobbit" cannot list resource "pods" in API group "" in the namespace "prod"

# Пробуем удалить под fedora в неймспейсе stage
% kubectl --kubeconfig ~/.kube/cluster.local-hobbit-kube.conf delete po/fedora 
Error from server (Forbidden): pods "fedora" is forbidden: User "system:serviceaccount:stage:hobbit" cannot delete resource "pods" in API group "" in the namespace "stage"
```
