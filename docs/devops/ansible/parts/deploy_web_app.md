    {% raw %}
    ```yml
      ---
      - name: Deploy web application with configuration
        hosts: web_servers
        become: yes
        gather_facts: yes
        
        vars:
            # Конфигурация приложения в JSON
            app_config_json: |
            {
                "app_name": "mywebapp",
                "version": "2.1.0",
                "environments": {
                "development": {
                    "debug": true,
                    "log_level": "DEBUG",
                    "cache_enabled": false,
                    "workers": 1
                },
                "production": {
                    "debug": false,
                    "log_level": "INFO",
                    "cache_enabled": true,
                    "workers": 4
                }
                },
                "features": ["auth", "api", "admin", "analytics"],
                "dependencies": ["python3-pip", "python3-flask", "nginx", "git"]
            }
            
            # Используем другое имя вместо зарезервированного 'environment'
            deploy_env: "{{ target_env | default('development') }}"
            app_config: "{{ app_config_json | from_json }}"
            
        tasks:
            # 1. Установка зависимостей с условиями
            - name: Install dependencies
            ansible.builtin.apt:
                name: "{{ item }}"
                state: present
                update_cache: yes
            loop: "{{ app_config.dependencies }}"
            
            # 2. Создание конфигурации на основе окружения
            - name: Create application config file
            ansible.builtin.copy:
                content: |
                # Ansible managed - {{ app_config.app_name }} v{{ app_config.version }}
                # Environment: {{ deploy_env }}
                
                DEBUG = {{ app_config.environments[deploy_env].debug }}
                LOG_LEVEL = "{{ app_config.environments[deploy_env].log_level }}"
                CACHE_ENABLED = {{ app_config.environments[deploy_env].cache_enabled }}
                WORKERS = {{ app_config.environments[deploy_env].workers }}
                
                FEATURES = {{ app_config.features | to_json }}
                
                # System info
                HOSTNAME = "{{ ansible_facts['hostname'] }}"
                CPU_CORES = {{ ansible_facts['processor_cores'] }}
                TOTAL_RAM_MB = {{ ansible_facts['memtotal_mb'] }}
                dest: "/etc/{{ app_config.app_name }}.conf"
                mode: '0644'
            notify: restart_app
            
            # 3. Включение/выключение функций на основе условий
            - name: Enable/disable features based on environment
            ansible.builtin.debug:
                msg: |
                Feature '{{ item }}' is {{ 'ENABLED' if item in app_config.features else 'DISABLED' }}
            loop: "{{ ['auth', 'api', 'admin', 'analytics', 'metrics', 'docs'] }}"
            
            # 4. Конфигурация для production окружения
            - name: Production-specific tasks
            ansible.builtin.debug:
                msg: "Production optimization: Setting up monitoring and backups"
            when: 
                - deploy_env == "production"
                - monitoring_enabled | default(false) | bool
                
            - name: Configure production settings
            ansible.builtin.copy:
                content: |
                # Production specific settings
                WORKER_PROCESSES = {{ ansible_facts['processor_cores'] * 2 }}
                MAX_REQUESTS = 10000
                SSL_ENABLED = true
                dest: "/etc/{{ app_config.app_name }}_production.conf"
                mode: '0644'
            when: deploy_env == "production"
            
            # 5. Отчет о деплое
            - name: Deployment summary
            ansible.builtin.debug:
                msg: |
                ==========================================
                DEPLOYMENT SUMMARY
                ==========================================
                Application: {{ app_config.app_name }}
                Version: {{ app_config.version }}
                Environment: {{ deploy_env }}
                Target hosts: {{ ansible_play_hosts | join(', ') }}
                
                Configuration:
                - Debug mode: {{ app_config.environments[deploy_env].debug }}
                - Log level: {{ app_config.environments[deploy_env].log_level }}
                - Cache: {{ 'enabled' if app_config.environments[deploy_env].cache_enabled else 'disabled' }}
                - Workers: {{ app_config.environments[deploy_env].workers }}
                
                Features enabled: {{ app_config.features | join(', ') }}
                
                System resources (average):
                - CPU cores: {{ ansible_facts['processor_cores'] }}
                - RAM: {{ ansible_facts['memtotal_mb'] }} MB
                ==========================================
            run_once: yes
            
        handlers:
            - name: restart_app
            ansible.builtin.debug:
                msg: "Application would restart here"
    ```
    {% endraw %}