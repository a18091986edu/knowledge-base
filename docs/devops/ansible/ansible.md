# 
!!! tip ""
    ```Ansible - безагентный инструмент автоматизации. Он подключается к узлам по SSH (или WinRM) и выполняет отправленные модули (Python скрипты), после чего они удаляются.```


<div style="border: 2px solid #ccc; padding: 3px; border-radius: 10px; text-align: center; background: #f9f9f9;">
<h3>Когда ты админишь 200 серверов, тебе нужно два навыка:<br> писать YAML и молиться</h3>
</div>


???+ example "commands"
{% include "devops/ansible/parts/commands.md" %}

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

??? example "Get Facts Playbook"
{% include "devops/ansible/parts/playbook_facts.md" %}