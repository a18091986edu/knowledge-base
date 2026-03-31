    {% raw %}
    
    ```bash
    #####################   group_vars/all.yml   ######################
    # Переменные для всех хостов (самый низкий приоритет)
    ---
    maintainer: "Ansible Team"
    environment_: "development"
    monitoring_enabled: true
    backup_enabled: false
    ntp_servers:
    - pool.ntp.org
    - time.google.com
    
    #####################   group_vars/web_servers.yml   ######################
    ---
    # Переменные для веб-серверов
    web_port: 80
    web_root: "/var/www/html"
    max_clients: 100
    app_version: "1.2.3"

    #####################   host_vars/node1.yml   ######################
    ---
    # Специфичные настройки для node1
    web_port: 8080  # Переопределяем групповую переменную
    node_role: "primary"
    custom_message: "Welcome to Node 1 - Primary Server"
    #####################   host_vars/node2.yml   ######################
    ---
    # Специфичные настройки для node2
    node_role: "secondary"
    custom_message: "Welcome to Node 2 - Secondary Server"
    
    ```

    {% endraw %}