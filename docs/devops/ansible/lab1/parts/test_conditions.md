    {% raw %}
    ```yaml
      ---
      - name: Demonstrate conditionals
        hosts: web_servers
        gather_facts: yes
        
        tasks:
            # Простое условие
            - name: Task for node1 only
            ansible.builtin.debug:
                msg: "This task runs only on node1"
            when: ansible_facts['hostname'] == "node1"
            
            # Условие с несколькими вариантами (с проверкой существования переменной)
            - name: Role-specific message
            ansible.builtin.debug:
                msg: "Primary node message"
            when: node_role is defined and node_role == "primary"
            
            # Условие с and/or (с проверкой существования переменных)
            - name: Condition with AND
            ansible.builtin.debug:
                msg: "High traffic server"
            when: 
                - web_port is defined
                - max_clients is defined
                - web_port == 8080
                - max_clients > 50
                
            # Условие с проверкой существования переменной
            - name: Check if variable exists
            ansible.builtin.debug:
                msg: "Backup is {{ 'enabled' if backup_enabled else 'disabled' }}"
            when: backup_enabled is defined
                
            # Условие на основе фактов системы
            - name: Debian specific task
            ansible.builtin.debug:
                msg: "This is {{ ansible_facts['distribution'] }} {{ ansible_facts['distribution_version'] }}"
            when: ansible_facts['os_family'] == "Debian"
            
            # Комплексное условие (с проверкой существования переменных)
            - name: Complex condition
            ansible.builtin.debug:
                msg: "Special configuration needed"
            when: 
                - ansible_facts['memtotal_mb'] is defined
                - ansible_facts['memtotal_mb'] < 2048
                - environment is defined
                - environment == "development"
                - monitoring_enabled is defined
                - monitoring_enabled | bool
    ```
    {% endraw %}