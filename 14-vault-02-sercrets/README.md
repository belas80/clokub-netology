# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

## Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl  
[vault-pod.yml](src/vault-pod.yml)

```shell
% kubectl apply -f src/vault-pod.yml 
pod/14.2-netology-vault created
```

Получить значение внутреннего IP пода

```shell
% kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"10.233.90.99"}]
```

Запустить второй модуль для использования в качестве клиента

```shell
% kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1#
```

Установить дополнительные пакеты

```
dnf -y install pip
pip install hvac
```
```shell
# Вывод из CLI
sh-5.1# dnf -y install pip
Fedora 36 - x86_64                                                                                                                           23 MB/s |  81 MB     00:03    
Fedora 36 openh264 (From Cisco) - x86_64                                                                                                    1.2 kB/s | 2.5 kB     00:02    
Fedora Modular 36 - x86_64                                                                                                                  5.4 MB/s | 2.4 MB     00:00    
Fedora 36 - x86_64 - Updates                                                                                                                 22 MB/s |  25 MB     00:01    
Fedora Modular 36 - x86_64 - Updates                                                                                                        1.8 MB/s | 2.5 MB     00:01    
Dependencies resolved.
============================================================================================================================================================================
 Package                                         Architecture                        Version                                      Repository                           Size
============================================================================================================================================================================
Installing:
 python3-pip                                     noarch                              21.3.1-2.fc36                                fedora                              1.8 M
Installing weak dependencies:
 libxcrypt-compat                                x86_64                              4.4.28-1.fc36                                fedora                               90 k
 python3-setuptools                              noarch                              59.6.0-2.fc36                                fedora                              936 k

Transaction Summary
============================================================================================================================================================================
Install  3 Packages

Total download size: 2.8 M
Installed size: 14 M
Downloading Packages:
(1/3): python3-pip-21.3.1-2.fc36.noarch.rpm                                                                                                  37 MB/s | 1.8 MB     00:00    
(2/3): python3-setuptools-59.6.0-2.fc36.noarch.rpm                                                                                          7.9 MB/s | 936 kB     00:00    
(3/3): libxcrypt-compat-4.4.28-1.fc36.x86_64.rpm                                                                                            742 kB/s |  90 kB     00:00    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                       3.8 MB/s | 2.8 MB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                    1/1 
  Installing       : python3-setuptools-59.6.0-2.fc36.noarch                                                                                                            1/3 
  Installing       : libxcrypt-compat-4.4.28-1.fc36.x86_64                                                                                                              2/3 
  Installing       : python3-pip-21.3.1-2.fc36.noarch                                                                                                                   3/3 
  Running scriptlet: python3-pip-21.3.1-2.fc36.noarch                                                                                                                   3/3 
  Verifying        : libxcrypt-compat-4.4.28-1.fc36.x86_64                                                                                                              1/3 
  Verifying        : python3-pip-21.3.1-2.fc36.noarch                                                                                                                   2/3 
  Verifying        : python3-setuptools-59.6.0-2.fc36.noarch                                                                                                            3/3 

Installed:
  libxcrypt-compat-4.4.28-1.fc36.x86_64                     python3-pip-21.3.1-2.fc36.noarch                     python3-setuptools-59.6.0-2.fc36.noarch                    

Complete!


sh-5.1# pip install hvac
Collecting hvac
  Downloading hvac-0.11.2-py2.py3-none-any.whl (148 kB)
     |████████████████████████████████| 148 kB 2.0 MB/s            
Collecting requests>=2.21.0
  Downloading requests-2.28.1-py3-none-any.whl (62 kB)
     |████████████████████████████████| 62 kB 1.4 MB/s             
Collecting six>=1.5.0
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting charset-normalizer<3,>=2
  Downloading charset_normalizer-2.1.0-py3-none-any.whl (39 kB)
Collecting idna<4,>=2.5
  Downloading idna-3.3-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 7.1 MB/s             
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.11-py2.py3-none-any.whl (139 kB)
     |████████████████████████████████| 139 kB 19.2 MB/s            
Collecting certifi>=2017.4.17
  Downloading certifi-2022.6.15-py3-none-any.whl (160 kB)
     |████████████████████████████████| 160 kB 34.5 MB/s            
Installing collected packages: urllib3, idna, charset-normalizer, certifi, six, requests, hvac
Successfully installed certifi-2022.6.15 charset-normalizer-2.1.0 hvac-0.11.2 idna-3.3 requests-2.28.1 six-1.16.0 urllib3-1.26.11
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
sh-5.1#
```

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

```
import hvac
client = hvac.Client(
    url='http://10.10.133.71:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```
```shell
# Вывод из CLI
sh-5.1# python3
Python 3.10.4 (main, Mar 25 2022, 00:00:00) [GCC 12.0.1 20220308 (Red Hat 12.0.1-0)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import hvac
>>> client = hvac.Client(
...     url='http://10.233.90.99:8200',
...     token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
True
>>> 
>>> client.secrets.kv.v2.create_or_update_secret(
...     path='hvac',
...     secret=dict(netology='Big secret!!!'),
... )
{'request_id': '79b4298b-59e3-3b9d-fadf-dd47f8b10e0c', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-08-07T20:17:11.086449435Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 
>>> client.secrets.kv.v2.read_secret_version(
...     path='hvac',
... )
{'request_id': '045a4c67-12d9-10d5-5903-9bb4badac914', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-08-07T20:17:11.086449435Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 
```
