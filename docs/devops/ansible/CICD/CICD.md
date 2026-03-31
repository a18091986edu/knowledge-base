### Настройка Ansible контроллера


!!! tip "структура папок"
```
ansible/
    ├── group_vars
    │   └── all.yml
    ├── inventory
    │   └── hosts.ini
    ├── playbook.yml
    └── roles
        └── common
            └── tasks
                └── main.yml

```

??? example "controller_config.sh"
{% include "devops/ansible/CICD/parts/controller_config.sh" %}

??? example "create_ansible_structure.sh"
{% include "devops/ansible/CICD/parts/create_ansible_structure.sh" %}
  

- корректируем /$HOME/ansible/inventory/hosts, добавляем IP-адреса серверов

- копируем публичный ключ и переносим его на настраиваемый серевер в ~/.ssh/authorized_keys

- ??? example "controller_config.sh"
{% include "devops/ansible/CICD/parts/bootstrap.sh" %}


### Пример проекта c использование настроенного контроллера


!!! tip "структура папок"
```
└── AppCICD/
    ├── .github/
    │   └── workflows/
    │       └── deploy.yml
    ├── app/
    │   └── main.py
    ├── docker-compose.yml
    ├── Dockerfile
    ├── playbook.yml
    ├── pyproject.toml
```

В github actions секреты:

```
DOCKERHUB_TOKEN
DOCKERHUB_USERNAME
POSTGRES_DB
POSTGRES_PASSWORD
POSTGRES_USER
SERVER_IP
SERVER_USER
SSH_KEY - приватный ключ для подклбчения в машине с Ansible (например, взять с машины, с которой захожу по SSH)
```

???+ example "Dockerfile"
{% include "devops/ansible/CICD/parts/Dockerfile" %}

???+ example "docker-compose.yml"
{% include "devops/ansible/CICD/parts/docker-compose.yml" %}

???+ example "playbook.yml"
{% include "devops/ansible/CICD/parts/playbook.yml" %}

???+ example "pyproject.toml"
{% include "devops/ansible/CICD/parts/pyproject.toml" %}

???+ example "main.py"
{% include "devops/ansible/CICD/parts/main.py" %}

???+ example "deploy.yml"
{% include "devops/ansible/CICD/parts/deploy.yml" %}