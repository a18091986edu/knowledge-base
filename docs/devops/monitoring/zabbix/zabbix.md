- [Stepik. Zabbix - система мониторинга статусов](https://stepik.org/course/186347/syllabus){target='_blank'}
- [Stepik. Демо курс Zabbix 6. Мониторинг IT инфраструктуры предприятия](https://stepik.org/course/226879/promo?search=9123764204){target='_blank'}
- [Stepik. Monitoring IT (базовый)](https://stepik.org/lesson/1212797/step/4?unit=1226051){target='_blank'}

??? "Установка сервера"
    ### Установка сервера
    ```docker
    services:
        postgres-server:
            image: postgres:17-alpine
            restart: always
            volumes:
            - postgres-data:/var/lib/postgresql/data
            environment:
            - POSTGRES_USER=zabbix
            - POSTGRES_PASSWORD=zabbix
            - POSTGRES_DB=zabbix
            healthcheck:
            test: ["CMD-SHELL", "pg_isready -U zabbix"]
            interval: 10s
            timeout: 5s
            retries: 5

        server:
            image: zabbix/zabbix-server-pgsql:alpine-latest
            ports:
            - "10051:10051"
            volumes:
            - /etc/localtime:/etc/localtime:ro
            - /etc/timezone:/etc/timezone:ro
            - /usr/lib/zabbix/alertscripts:/usr/lib/zabbix/alertscripts:ro
            - /usr/lib/zabbix/externalscripts:/usr/lib/zabbix/externalscripts:ro
            - /var/lib/zabbix/export:/var/lib/zabbix/export:rw
            - /var/lib/zabbix/modules:/var/lib/zabbix/modules:ro
            - /var/lib/zabbix/enc:/var/lib/zabbix/enc:ro
            - /var/lib/zabbix/ssh_keys:/var/lib/zabbix/ssh_keys:ro
            - /var/lib/zabbix/mibs:/var/lib/zabbix/mibs:ro
            - /var/lib/zabbix/snmptraps:/var/lib/zabbix/snmptraps:ro
            restart: always
            depends_on:
            postgres-server:
                condition: service_healthy
            environment:
            - POSTGRES_USER=zabbix
            - POSTGRES_PASSWORD=zabbix
            - POSTGRES_DB=zabbix
            - ZBX_HISTORYSTORAGETYPES=log,text
            - ZBX_DEBUGLEVEL=1
            - ZBX_HOUSEKEEPINGFREQUENCY=1
            - ZBX_MAXHOUSEKEEPERDELETE=5000
            - ZBX_PROXYCONFIGFREQUENCY=3600

        web-nginx-pgsql:
            image: zabbix/zabbix-web-nginx-pgsql:alpine-latest
            ports:
            - "80:8080"
            - "443:8443"
            volumes:
            - /etc/localtime:/etc/localtime:ro
            - /etc/timezone:/etc/timezone:ro
            - /etc/ssl/nginx:/etc/ssl/nginx:ro
            - /usr/share/zabbix/modules/:/usr/share/zabbix/modules/:ro
            healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost:8080/"]
            interval: 10s
            timeout: 5s
            retries: 3
            start_period: 30s
            sysctls:
            - net.core.somaxconn=65535
            restart: always
            depends_on:
            server:
                condition: service_started
            postgres-server:
                condition: service_healthy
            environment:
            - POSTGRES_USER=zabbix
            - POSTGRES_PASSWORD=zabbix
            - POSTGRES_DB=zabbix
            - ZBX_SERVER_HOST=server
            - ZBX_POSTMAXSIZE=64M
            - PHP_TZ=Europe/Moscow
            - ZBX_MAXEXECUTIONTIME=500

        volumes:
            postgres-data:
    ```

??? "Установка агента"
    ### Установка агента
    ```docker
    wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu24.04_all.deb
    sudo dpkg -i zabbix-release_6.4-1+ubuntu24.04_all.deb
    sudo apt update

    # Очистка кэша (apt аналог dnf clean all)
    sudo apt clean all

    # Установка Zabbix Agent 2 и всех плагинов
    sudo apt install -y zabbix-agent2 zabbix-agent2-plugin-*

    # Перезапуск и автозагрузка
    sudo systemctl restart zabbix-agent2
    sudo systemctl enable zabbix-agent2

    sudo nano /etc/zabbix/zabbix_agent2.conf
    Server=0.0.0.0/0
    sudo systemctl restart zabbix-agent2
    
    sudo apt update && sudo apt install zabbix-get
    zabbix_get -s 192.168.2.177 -p 10050 -k "agent.ping"

    docker exec -it <zabbix_server> zabbix_get -s 192.168.2.177 -p 10050 -k "agent.ping"
    ```

- [Установка сервера](https://stepik.org/lesson/1143783/step/1?unit=1155630){target='_blank'}
- [Установка агента](https://stepik.org/lesson/1143786/step/1?unit=1155633){target='_blank'}
- [Конфигурирование](https://stepik.org/lesson/1143787/step/1?unit=1155634){target='_blank'}
