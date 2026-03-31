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

??? example "Nginx Install Playbook"
{% include "devops/ansible/lab1/parts/playbook_install_nginx.md" %}

!!! tip "Запуск и проверка"
```
ansible-playbook -i /ansible/inventory.ini /ansible/playbook_01_nginx.yml

# Проверяем, что Nginx работает
curl http://172.25.0.11
curl http://172.25.0.12

# Или через Ansible
ansible -i /ansible/inventory.ini web_servers -m uri -a "url=http://localhost"
```

??? example "Get Facts Playbook"
{% include "devops/ansible/lab1/parts/playbook_facts.md" %}


## Variables

- Переменные в Ansible могут быть определены в разных местах. Создадим иерархию переменных

!!! tip ""
```
# В контейнере ansible_controller
cd /ansible
# Создаем структуру директорий для переменных
mkdir -p group_vars host_vars
```

??? example "create vars"
{% include "devops/ansible/lab1/parts/vars/vars.md" %}

??? example "test vars priority"
{% include "devops/ansible/lab1/parts/vars/test_vars_priority.md" %}


!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/test_vars_priority.yml
```

## Conditions


??? example "conditions"
{% include "devops/ansible/lab1/parts/test_conditions.md" %}

!!! tip ""
```
# Для development окружения (по умолчанию)
ansible-playbook -i /ansible/inventory.ini /ansible/deploy_web_app.yml

# Для development окружения явно
ansible-playbook -i /ansible/inventory.ini /ansible/deploy_web_app.yml -e "target_env=development"

# Для production окружения
ansible-playbook -i /ansible/inventory.ini /ansible/deploy_web_app.yml -e "target_env=production"
```

## Loops и JSON


??? example "test loops"
{% include "devops/ansible/lab1/parts/test_loops.md" %}

!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/test_loops.yml
```

??? example "create users from json"
{% include "devops/ansible/lab1/parts/create_users_from_json.md" %}


!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/create_users_from_json.yml
```

## Filter

??? example "filters"
{% include "devops/ansible/lab1/parts/test_filters.md" %}

!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/test_filters.yml
```

## Vars + Conditions + Loops + Filter Example

??? example "deploy web app"
{% include "devops/ansible/lab1/parts/deploy_web_app.md" %}

!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/deploy_web_app.yml -e "environment=development"
ansible-playbook -i /ansible/inventory.ini /ansible/deploy_web_app.yml -e "environment=production"

```