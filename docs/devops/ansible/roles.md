# 
Способ организации повторно используемого кода Ansible. Вместо того чтобы писать один большой playbook, мы разбиваем его на логические компоненты.

!!! tip "подготовка проекта"
```
# В контейнере ansible_controller
cd /ansible/roles

# Создаем структуру для роли postgres
mkdir -p postgres/{tasks,handlers,defaults,vars,templates,meta,files}

# Проверяем структуру
tree postgres/

roles/
└── postgres
    ├── README.md
    ├── defaults
    │   └── main.yml
    ├── files
    ├── handlers
    │   └── main.yml
    ├── meta
    │   └── main.yml
    ├── tasks
    │   └── main.yml
    ├── templates
    │   ├── pga_hba.conf.j2
    │   └── postgresql.conf.j2
    └── vars
        └── main.yml

```

