#

- Создадим с помощью Docker четыре экспериментальных контейнера, один из которых будет ansible контроллером, а остальные будем с его помощью настраивать и устанавливать ПО

```
Физический сервер
    └── Docker Engine
        ├── ansible_controller (Alpine Linux)  ← управляющая машина
        ├── node1 (Ubuntu 22.04)               ← управляемый хост
        ├── node2 (Ubuntu 22.04)               ← управляемый хост
        └── node3 (Ubuntu 22.04)               ← управляемый хост
```

??? tip "Docker-compose.yml"
{% include "devops/ansible/lab1/parts/prepare_containers.md" %}

??? tip "Настройка"
{% include "devops/ansible/lab1/parts/configuration.md" %}

!!! tip "inventory.ini"
```
[web_servers]              # Группа хостов
node1 ansible_host=172.25.0.11    # хост с переменной ansible_host
node2 ansible_host=172.25.0.12

[database_servers]         # Другая группа
node3 ansible_host=172.25.0.13

[all:vars]                 # Переменные для всех хостов
ansible_user=root
ansible_python_interpreter=/usr/bin/python3
```

!!! tip "Hellow world в ansible"
```
ansible all -m ping

модуль проверяет:
- доступность хоста по ssh
- наличие python
- возможность выполнить python код

успешный ответ:
{
    "changed": false,           // ничего не изменилось на сервере
    "ping": "pong"              // ответ от модуля
}
```