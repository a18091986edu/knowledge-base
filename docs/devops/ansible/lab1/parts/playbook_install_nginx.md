    {% raw %}
    ```bash
      ---
        # СИГНАТУРА НАЧАЛА ДОКУМЕНТА YAML

        # ОПИСАНИЕ ПЛЕЙБУКА
      - name: Install and configure Nginx  # Название задачи (плейбука)
        hosts: web_servers                 # Применяется к группе хостов web_servers из inventory-файла
        become: yes                        # Повышение привилегий (sudo) для установки пакетов
        gather_facts: yes                  # Сбор информации о хостах (ОС, IP, память и т.д.)
        

        # ОБРАБОТЧИКИ (выполняются только при вызове notify)
        handlers:
            - name: Restart Nginx                    # Имя обработчика
            # ansible.builtin.systemd:               # Модуль systemd для перезагрузки сервиса
            #   name: nginx
            #   state: restarted
            # Альтернатива для Docker (если systemd недоступен):
            ansible.builtin.command:
                cmd: /usr/sbin/nginx -s reload

        # СПИСОК ЗАДАЧ
        tasks:
            # 1. ОБНОВЛЕНИЕ КЭША APT
            - name: Update apt cache          # Описание задачи
            ansible.builtin.apt:            # Модуль apt для Debian/Ubuntu
                update_cache: yes             # Обновить кэш пакетов (apt update)
                cache_valid_time: 3600        # Считать кэш валидным 1 час (не обновлять чаще)
            
            # 2. УСТАНОВКА NGINX
            - name: Install Nginx
            ansible.builtin.apt:
                name: nginx                   # Имя пакета
                state: present                # Установить пакет (present - установить, absent - удалить)
            notify: Restart Nginx           # Вызвать обработчик при изменении
                
            # 3. ЗАПУСК NGINX (ручной, так как systemd недоступен в Docker)
            - name: Start Nginx manually (since systemd not available in Docker)
            ansible.builtin.command:        # Модуль для выполнения команд
                cmd: /usr/sbin/nginx          # Команда для запуска Nginx
                creates: /run/nginx.pid       # Не выполнять, если файл PID уже существует
            register: nginx_start           # Сохранить результат выполнения в переменную nginx_start
            
            # 4. ВЫВОД СТАТУСА ЗАПУСКА NGINX
            - name: Show Nginx start status
            ansible.builtin.debug:          # Модуль для вывода отладочной информации
                msg: "Nginx started on {{ ansible_facts['hostname'] }}"  # Сообщение с именем хоста
            when: nginx_start.changed       # Выполнить только если Nginx был запущен (изменился)
                
            # 5. СОЗДАНИЕ ПОЛЬЗОВАТЕЛЬСКОЙ СТРАНИЦЫ С ФАКТАМИ ХОСТА
            - name: Create custom index page with facts
            ansible.builtin.copy:
                content: |
                <html>
                <head>
                    <title>
                    {% if ansible_facts['hostname'] == 'node1' %}
                    Web Server 1
                    {% elif ansible_facts['hostname'] == 'node2' %}
                    Web Server 2
                    {% else %}
                    Ansible Lab - {{ ansible_facts['hostname'] }}
                    {% endif %}
                    </title>
                </head>
                <body>
                <h1>
                {% if ansible_facts['hostname'] == 'node1' %}
                    Web Server 1
                {% elif ansible_facts['hostname'] == 'node2' %}
                    Web Server 2
                {% else %}
                    Hello from Ansible!
                {% endif %}
                </h1>
                <p>This server is managed by Ansible.</p>
                <p>Hostname: {{ ansible_facts['hostname'] }}</p>
                <p>IP Address: {{ ansible_facts['default_ipv4']['address'] }}</p>
                <p>OS: {{ ansible_facts['distribution'] }} {{ ansible_facts['distribution_version'] }}</p>
                <p>CPU Cores: {{ ansible_facts['processor_cores'] }}</p>
                <p>Memory: {{ ansible_facts['memtotal_mb'] }} MB</p>
                </body>
                </html>
                dest: /var/www/html/index.html
                mode: '0644'
            notify: Restart Nginx                  # Вызвать обработчик при изменении конфигурации
                
            # 6. ПРОВЕРКА, ЧТО ПОРТ 80 ОТКРЫТ
            - name: Check if port 80 is listening
            ansible.builtin.wait_for:             # Модуль ожидания состояния порта
                port: 80                            # Проверяемый порт
                host: "{{ ansible_facts['default_ipv4']['address'] }}"  # IP-адрес хоста
                state: started                      # Ожидаем, что порт начал слушать
                timeout: 10                         # Таймаут 10 секунд
                delay: 1                            # Задержка перед первой проверкой 1 секунда
            register: port_check                  # Сохраняем результат проверки
            
            # 7. ВЫВОД РЕЗУЛЬТАТА ПРОВЕРКИ ПОРТА
            - name: Show port 80 status
            ansible.builtin.debug:
                msg: "Port 80 is open and listening on {{ ansible_facts['hostname'] }}"
            when: port_check.state == 'started'

            # 9. ВЫВОД РЕЗУЛЬТАТА ПРОВЕРКИ NGINX
            - name: Show verification result
            ansible.builtin.debug:
                msg: "Nginx is running and serving content on {{ ansible_facts['hostname'] }}"
                
            # 8. ВЫВОД ЗАГОЛОВКА СТРАНИЦЫ (извлечение с помощью регулярного выражения)
            - name: Display webpage title
            ansible.builtin.debug:
                msg: "Webpage title: {{ webpage.content | regex_search('<title>(.*)</title>', '\\1') | first }}"
                # regex_search ищет содержимое тега <title>, извлекает первую группу (.*), берёт первый элемент
            when: webpage.content is defined  # Выполнить, если содержимое страницы определено
            
            # 11. ИТОГОВАЯ СВОДКА
            - name: Summary of changes
            ansible.builtin.debug:
                msg: |
                Playbook completed successfully!
                Hosts: {{ ansible_play_hosts | join(', ') }}
                Total tasks: {{ ansible_run_tags | length }}
                Port 80 status: {{ 'open' if port_check.state == 'started' else 'closed' }}
            run_once: yes                          # Выполнить задачу только один раз (на первом хосте)
    ```
    {% endraw %}