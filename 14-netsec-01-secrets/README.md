# 14.1 Создание и использование секретов  

## Задача 1: Работа с секретами через утилиту kubectl

Выполните приведённые ниже команды в консоли, получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать секрет?

```shell
# Создание ключа RSA
% openssl genrsa -out cert.key 4096
Generating RSA private key, 4096 bit long modulus
......................................................................................................++
...............................................................................................................................................................................++
e is 65537 (0x10001)

# Создание сертификата с помощью созданного ключа RSA
% openssl req -x509 -new -key certs/cert.key -days 3650 -out certs/cert.crt \
-subj '/C=RU/ST=Yekaterinburg/L=Yekaterinburg/CN=cp1.ru-central1.internal'

# Создание секрета
% kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
secret/domain-cert created
```

### Как просмотреть список секретов?

```shell
% kubectl get secrets
NAME                  TYPE                                  DATA   AGE
default-token-slvpk   kubernetes.io/service-account-token   3      35d
domain-cert           kubernetes.io/tls                     2      3m25s

% kubectl get secret
NAME                  TYPE                                  DATA   AGE
default-token-slvpk   kubernetes.io/service-account-token   3      35d
domain-cert           kubernetes.io/tls                     2      6m5s
```

### Как просмотреть секрет?

```shell
% kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      7m8s

% kubectl describe secret domain-cert
Name:         domain-cert
Namespace:    stage
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.crt:  1874 bytes
tls.key:  3243 bytes
```

### Как получить информацию в формате YAML и/или JSON?

```shell
% kubectl get secret domain-cert -o yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiBDUUVCQlFBR........TkQgQ0VSVElGSUNBVEUtLS0tLQo=
  tls.key: LS0tLS1CRUdJTiBSU0EgUFJJV........UlNBIFBSSVZBVEUgS0VZLS0tLS0K
kind: Secret
metadata:
  creationTimestamp: "2022-07-30T17:08:18Z"
  name: domain-cert
  namespace: stage
  resourceVersion: "196460"
  uid: 0646e9fd-8e5f-4453-b469-905a04365d27
type: kubernetes.io/tls

% kubectl get secret domain-cert -o json
{
    "apiVersion": "v1",
    "data": {
        "tls.crt": "LS0tLS1CRUdJTiBDUUVCQlFBR........TkQgQ0VSVElGSUNBVEUtLS0tLQo=",
        "tls.key": "LS0tLS1CRUdJTiBSU0EgUFJJV........UlNBIFBSSVZBVEUgS0VZLS0tLS0K"
    },
    "kind": "Secret",
    "metadata": {
        "creationTimestamp": "2022-07-30T17:08:18Z",
        "name": "domain-cert",
        "namespace": "stage",
        "resourceVersion": "196460",
        "uid": "0646e9fd-8e5f-4453-b469-905a04365d27"
    },
    "type": "kubernetes.io/tls"
}
```

### Как выгрузить секрет и сохранить его в файл?

```shell
% kubectl get secrets -o json > secrets.json
% cat secrets.json 
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "ca.crt": "LS0tLS1CRUd......tCg==",
                "namespace": "c3RhZ2U=",
                "token": "ZXlKaGJHY2lP......qenhR"
            },
            "kind": "Secret",
            "metadata": {
                "annotations": {
                    "kubernetes.io/service-account.name": "default",
                    "kubernetes.io/service-account.uid": "3ad0df78-7d6a-415d-ad8e-686c8f6b7857"
                },
                "creationTimestamp": "2022-06-24T18:30:42Z",
                "name": "default-token-slvpk",
                "namespace": "stage",
                "resourceVersion": "4184",
                "uid": "21bb7e40-fbe4-4ac3-aa8d-11706058cfba"
            },
            "type": "kubernetes.io/service-account-token"
        },
        {
            "apiVersion": "v1",
            "data": {
                "tls.crt": "LS0tLS1CRUd......LS0tLQo=",
                "tls.key": "LS0tLS1CRUd......0tLS0K"
            },
            "kind": "Secret",
            "metadata": {
                "creationTimestamp": "2022-07-30T17:08:18Z",
                "name": "domain-cert",
                "namespace": "stage",
                "resourceVersion": "196460",
                "uid": "0646e9fd-8e5f-4453-b469-905a04365d27"
            },
            "type": "kubernetes.io/tls"
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}

% kubectl get secret domain-cert -o yaml > domain-cert.yml
% cat domain-cert.yml 
apiVersion: v1
data:
  tls.crt: LS0tL....tLQo=
  tls.key: LS0tL....tLS0K
kind: Secret
metadata:
  creationTimestamp: "2022-07-30T17:08:18Z"
  name: domain-cert
  namespace: stage
  resourceVersion: "196460"
  uid: 0646e9fd-8e5f-4453-b469-905a04365d27
type: kubernetes.io/tls
```

### Как удалить секрет?

```shell
% kubectl delete secret domain-cert
secret "domain-cert" deleted

 % kubectl get secrets 
NAME                  TYPE                                  DATA   AGE
default-token-slvpk   kubernetes.io/service-account-token   3      35d
```

### Как загрузить секрет из файла?

```shell
% kubectl apply -f domain-cert.yml
secret/domain-cert created

% kubectl get secrets 
NAME                  TYPE                                  DATA   AGE
default-token-slvpk   kubernetes.io/service-account-token   3      35d
domain-cert           kubernetes.io/tls                     2      5s
```

## Задача 2 (*): Работа с секретами внутри модуля  

Выберите любимый образ контейнера, подключите секреты и проверьте их доступность
как в виде переменных окружения, так и в виде примонтированного тома.  

Создадим еще один секрет с парой имя и пароль:  
```shell
% kubectl create secret generic mysecret --from-literal MYNAME=admin --from-literal MYPASSWORD=MyVeryStrongPass
secret/mysecret created

% kubectl get secrets mysecret -o yaml                                                                         
apiVersion: v1
data:
  MYNAME: YWRtaW4=
  MYPASSWORD: TXlWZXJ5U3Ryb25nUGFzcw==
kind: Secret
metadata:
  creationTimestamp: "2022-07-30T19:57:01Z"
  name: mysecret
  namespace: stage
  resourceVersion: "218611"
  uid: ec934b71-5bad-4385-898d-944dcf2b84c4
type: Opaque
```

Создадим манифест [pod-with-secrets.yml](src/pod-with-secrets.yml) для пода, где подключим только что созданный секрет в виде переменной окружения, а секрет из предыдущего задания в виде примонтированного тома.  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
      protocol: TCP
    - containerPort: 443
      protocol: TCP
    volumeMounts:
    - name: certs
      mountPath: "/etc/nginx/ssl"
      readOnly: true
    envFrom:
    - secretRef:
        name: mysecret
  volumes:
  - name: certs
    secret:
      secretName: domain-cert
```
Проверяем.  
```shell
# Создаем pod
% kubectl apply -f src/pod-with-secrets.yml 
pod/my-pod created

# Проверим что создался
% kubectl get po
NAME     READY   STATUS    RESTARTS   AGE
my-pod   1/1     Running   0          24s

# Проверим наличие примонтированной папки ssl и ее содержимое 
 % kubectl exec po/my-pod -- ls /etc/nginx/ssl
tls.crt
tls.key
% kubectl exec po/my-pod -- cat /etc/nginx/ssl/tls.crt
-----BEGIN CERTIFICATE-----
MIIFPDCCAyQCCQDR0Mfo+30SyTANBgkqhkiG9w0BAQsFADBgMQswCQYDVQQGEwJS
...
...
VffjJHp4qhQZYUk3l8laSK2L0i8NlBV48kxmc1byXSwfuyw4KlqgaFL3KIKmCfFg
-----END CERTIFICATE-----

# Проверим переменные окружения
% kubectl exec po/my-pod -- env | grep MY    
MYPASSWORD=MyVeryStrongPass
MYNAME=admin
```
