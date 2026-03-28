    ```
    docker-compose up -d
    docker network inspect ansible_lab_network | grep -A 5 "IPv4Address"
    docker exec -it ansible_controller sh # заходим в контроллер
    apk update
    apk add ansible openssh-client openssh-keygen  py3-docker-py

    # Генерируем SSH ключ
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa

    # Добавляем узлы в known_hosts
    ssh-keyscan -H 172.25.0.11 >> /root/.ssh/known_hosts
    ssh-keyscan -H 172.25.0.12 >> /root/.ssh/known_hosts
    ssh-keyscan -H 172.25.0.13 >> /root/.ssh/known_hosts

    # Копируем ключ на узлы (пароль: password)
    ssh-copy-id root@172.25.0.11
    ssh-copy-id root@172.25.0.12
    ssh-copy-id root@172.25.0.13

    mkdir -p /ansible

    cat > /ansible/inventory.ini << 'EOF'
    [web_servers]
    node1 ansible_host=172.25.0.11
    node2 ansible_host=172.25.0.12

    [database_servers]
    node3 ansible_host=172.25.0.13

    [all:vars]
    ansible_user=root
    ansible_python_interpreter=/usr/bin/python3
    EOF

    # Проверяем подключение
    ansible -i /ansible/inventory.ini all -m ping
    ```