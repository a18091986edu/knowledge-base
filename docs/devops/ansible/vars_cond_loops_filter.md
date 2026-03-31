#

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
{% include "devops/ansible/parts/vars/vars.md" %}

??? example "test vars priority"
{% include "devops/ansible/parts/vars/test_vars_priority.md" %}


!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/test_vars_priority.yml
```

## Conditions


??? example "conditions"
{% include "devops/ansible/parts/test_conditions.md" %}

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
{% include "devops/ansible/parts/test_loops.md" %}

!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/test_loops.yml
```

??? example "create users from json"
{% include "devops/ansible/parts/create_users_from_json.md" %}


!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/create_users_from_json.yml
```

## Filter

??? example "filters"
{% include "devops/ansible/parts/test_filters.md" %}

!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/test_filters.yml
```

## Vars + Conditions + Loops + Filter Example

??? example "deploy web app"
{% include "devops/ansible/parts/deploy_web_app.md" %}

!!! tip ""
```
ansible-playbook -i /ansible/inventory.ini /ansible/deploy_web_app.yml -e "environment=development"
ansible-playbook -i /ansible/inventory.ini /ansible/deploy_web_app.yml -e "environment=production"

```